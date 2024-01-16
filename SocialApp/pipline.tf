# AWS CodeCommit Repository
resource "aws_codecommit_repository" "test" {
  repository_name = "SocialApp-Repo"
  description     = "This is the Sample App Repository"
}

# AWS S3 Bucket
resource "aws_s3_bucket" "buildartifactbucket" {
  bucket = "socialapp-buildartifactbucket"
}

# AWS CodeBuild Project
resource "aws_codebuild_project" "codebuild" {
  name          = "socialapp-build"
  description   = "socialappCodeBuild deployment"
  build_timeout = 60 
  service_role  = "arn:aws:iam::920119599456:role/cil-academy-cicd-codebuild-role"

  artifacts {
    type = "CODEPIPELINE"
    location = aws_s3_bucket.buildartifactbucket.bucket
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
  }

}

# AWS CodePipeline
resource "aws_codepipeline" "codepipeline" {
  name     = "socialapp-codepipeline"
  role_arn = "arn:aws:iam::920119599456:role/cil-academy-cicd-codepipeline-role"

  artifact_store {
    type      = "S3"
    location  = aws_s3_bucket.buildartifactbucket.bucket
  }

  stage {
    name = "Source"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "AWS"
      provider        = "CodeCommit"
      version         = "1"
      output_artifacts = ["socialapp-buildartifactbucket"]

      configuration = {
        RepositoryName = "socialapp-Repo"
        BranchName     = "master"
      }

      run_order = 1
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["socialapp-buildartifactbucket"]
      output_artifacts = ["BuildOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name
      }

      run_order = 2
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      version         = "1"
      input_artifacts = ["socialapp-buildartifactbucket"]

      configuration = {
        StackName   = "Group3webappstack"
        ActionMode  = "CREATE_UPDATE"
        RoleArn     = "arn:aws:iam::920119599456:role/cil-academy-cicd-cloudformation-role"
        TemplatePath = "socialapp-buildartifactbucket::Group3-Part2-Stack.yml"
      }

      run_order = 3
    }
  }
}
