# Social-App
Overview
This architecture represents the deployment and operation of a social application using Amazon Web Services (AWS). The main components include development tools, content delivery, user authentication, server infrastructure, data storage, monitoring, and security.

## The workflow outlined in the architecture is as follows:
The developer commits code changes to a version control system.(Codecommit)
This action triggers the CodePipeline, which retrieves the code from the code bucket.
The code undergoes a build process and upon successful completion, the deployment process is initiated.
Terraform code is used to define the infrastructure that will be updated or created in the AWS Account.
The updated application is deployed, making it available to verified users.
Users interact with the application through the domain (e.g., socialapp.com), with their requests served efficiently and securely via CloudFront.
All user requests pass through Web-ACL for security screening before reaching the web server.
Once authenticated through the user logins process, users can send requests that are processed by the web server.
The web server may retrieve data from an in-memory cache or a database, depending on the nature of the request.
Lambda functions may be triggered in response to certain events, such as updating a user profile or posting content.
All traffic between the internet and the application flows through the internet gateway.
CloudWatch is used for monitoring the application’s performance and health, and for sending notifications in case of issues.
AWS Shield provides additional protection against network and transport layer DDoS attacks.
## Security
IAM is used to ensure that only authorised entities can access and manage AWS resources.
Web-ACL as part of AWS WAF, provides a layer of security that helps to protect the web application from common web exploits that could affect application availability, compromise security, or consume excessive resources.
CloudFront works in conjunction with AWS WAF to provide an added layer of defence against network and application layer attacks.
AWS Shield provides DDoS protection, which is automatically included with AWS services such as CloudFront and can be further enhanced with AWS Shield Advanced for additional protection features.
The use of a VPC isolates the application environment in the cloud, providing a private subnet that can be securely accessed over the internet or through a VPN.
## Performance
CloudFront ensures content is delivered with the best possible performance by leveraging the globally distributed AWS edge locations.
In-memory caching reduces database load and improves the response time by caching read-heavy or compute-intensive data.
Lambda triggers allow for event-driven, scalable architectures that can grow or shrink based on demand.
## Monitoring and Management
CloudWatch offers insights into application performance and operational health, enabling teams to react swiftly to any metrics outside of the expected thresholds.
CodePipeline and CloudWatch can be configured to provide notifications on the CI/CD process, allowing teams to keep abreast of the deployment status and any issues that arise.
## Design Diagram
![Social App drawio (1)](https://github.com/ClementDaniel/Social-App/assets/96403532/a46a26e9-a50e-42cc-a85d-bd42cbd1c16a)

