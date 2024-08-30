# AWS 3-Tier Web Architecture with Terraform

This project demonstrates the deployment of a 3-Tier Web Architecture on AWS using Terraform. The architecture spans two Availability Zones (AZs) and includes the following components:

1. **Web Tier**: Consists of an Application Load Balancer (ALB) and an Auto Scaling Group (ASG) to manage web servers.
2. **App Tier**: Contains an internal ALB and an ASG to handle application servers.
3. **Database Tier**: Utilizes Amazon RDS for relational database management.

## Architecture Diagram

![My Project](https://github.com/user-attachments/assets/af74ac04-581d-4993-94a0-ac3fb4a0ab68)

## Modules

The project is organized into several Terraform modules to facilitate modularity and reuse:

- **`vpc`**: Defines the Virtual Private Cloud (VPC) and associated networking components.
- **`asg`**: Configures Auto Scaling Groups for the web and app tiers.
- **`alb`**: Sets up Application Load Balancers (ALBs) for routing traffic.
- **`rds`**: Manages the Amazon RDS instance for the database tier.
- **`security_group`**: Defines security groups for controlling inbound and outbound traffic to resources.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- AWS account with appropriate permissions
- [AWS CLI](https://aws.amazon.com/cli/) configured with your AWS credentials
- Jenkins installed with appropriate plugins for Terraform and AWS for Automated Deployment

## Automated Deployment with Jenkins

The project includes a Jenkins pipeline for automating the deployment and teardown of the infrastructure. To use Jenkins for managing the infrastructure, follow these steps:

1. **Create a Jenkins Pipeline Job**

    Set up a new pipeline job in Jenkins and configure it to use the `Jenkinsfile` provided in the repository.

2. **Run the Pipeline**

    - **To Apply the Infrastructure**: Run the Jenkins pipeline and select the apply stage to provision the infrastructure.
    - **To Destroy the Infrastructure**: Run the Jenkins pipeline and select the destroy stage to tear down the infrastructure.

The Jenkins pipeline automates the Terraform commands, including `init`, `plan`, `apply`, and `destroy`.

## Manual Deployment

To manually deploy the AWS 3-Tier Web Architecture using Terraform, follow these steps:

### 1. Clone the Repository

```bash
git clone https://github.com/Yusufabdulsttar/AWS-3-Tier-Web-Arch-Terraform.git
cd AWS-3-Tier-Web-Arch-Terraform
```

### 2. Initialize Terraform

Initialize the Terraform configuration by downloading the required providers.
```bash
terraform init
```

### 3. Plan the Infrastructure

Review the changes Terraform will apply.
```bash
terraform plan
```

### 4. Apply the Configuration

Deploy the infrastructure to AWS. You will need to confirm the action.
```bash
terraform apply
```

### 5. Access the Application

Once the deployment is complete, you can access your web application through the DNS name provided by the ALB in the web tier.

#### Endpoints
- http://<ALB_DNS>/init: This endpoint initializes the database by creating the required queries.
- http://<ALB_DNS>/users: This endpoint retrieves the data stored in the database.
Replace <ALB_DNS> with the actual DNS name provided by the Application Load Balancer after deployment.

### Tearing Down the Infrastructure
To destroy the infrastructure and avoid ongoing costs, run the following command:
```bash
terraform destroy
```
