# 🚀 Ruby on Rails App Deployment to AWS ECS (Fargate) with Terraform

This project demonstrates deploying a Ruby on Rails application to AWS using:

- **Amazon ECR**: Container image storage  
- **Amazon ECS (Fargate)**: Serverless container orchestration  
- **Amazon RDS (PostgreSQL)**: Managed relational database  
- **Amazon S3**: File storage with IAM authentication  
- **Elastic Load Balancer (ALB)**: Public traffic distribution  
- **Terraform**: Infrastructure as Code  

All services (except the Load Balancer) are deployed to private subnets for security.

---

## ✅ Features

- Dockerized Ruby on Rails app (Ruby 3.2.2, Rails 7.0.5)
- ECS Fargate tasks running in **private subnets**
- ALB in **public subnets** routing HTTP traffic to ECS
- RDS PostgreSQL database in private subnets
- S3 integration via IAM (no static credentials)
- CI/CD pipeline using GitHub Actions
- Fully reproducible infrastructure via Terraform

---

## 📦 Prerequisites

- AWS CLI configured with credentials
- Docker installed locally
- Terraform ≥ v1.6 installed
- GitHub repository with Actions enabled
- AWS IAM permissions to manage ECS, ECR, RDS, VPC, IAM, S3

---

## 🔐 GitHub Secrets Setup

In your GitHub repo, go to **Settings > Secrets and Variables > Actions**, and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

## 🐳 Docker Image Build & Push (GitHub Actions)

A GitHub Actions workflow (`.github/workflows/deploy.yml`) is provided to:

- Build Docker image from your Rails app
- Push it to Amazon ECR
- Trigger Terraform deploy

To trigger deployment, just push to the `main` branch.

> You can also build and push the Docker image manually:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

docker build -t ror-app .

docker tag ror-app:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/ror-app:latest

docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/ror-app:latest

```

## Steps to Deploy Manually 

Configure Terraform Variables

```
rds_db_name  = "your_db_name"
rds_username = "your_db_user"
rds_password = "your_secure_password"
```

These values will be injected into the ECS container as ENV variables.

## Deploy Infrastructure with Terraform
```
cd terraform

# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Apply and provision all resources
terraform apply -auto-approve
```

This will:

Create VPC, subnets, security groups

Create ECS Fargate cluster, task definition, and service

Deploy RDS PostgreSQL and S3 bucket

Configure ALB and route traffic to ECS

## Access the Application

```
Outputs:

alb_dns_name = ror-app-alb-xxxxxx.us-east-1.elb.amazonaws.com
```
