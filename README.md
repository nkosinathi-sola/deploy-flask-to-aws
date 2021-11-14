## Source Code Structure

```bash


├── app
│   ├── app.py
│   └── requirements.txt           
├── terraform                       
│    ├── alb.tf 
│    ├── main.tf
│    ├── network.tf 
│    ├── outputs.tf
│    ├── providers.tf  
│    └── variables.tf
│
├── .gitignore
├── Dockerfile
├── DEADME.md
├── docker-compose.yml
├── entrypoint.sh            
```

## Deploy a simple Flask app to AWS ECS with Terraform
Sets up the following AWS infrastructure:

- Networking:
    - VPC
    - Public and private subnets
    - Routing tables
    - Internet Gateway
- Security Groups
- Load Balancers, Listeners, and Target Groups
- ECS:
    - Task Definition
    - Cluster
    - Service

## Prerequisites
Install Docker
Install Terraform
Sign up for an AWS account
Set up AWS CLI profile

## How to run the application with Docker
On your terminal, 
1. Navigate to the root direcory of the project.
2. Run ```docker build . -t deploy_flask``` to build a new image from the source code.
3. Run ```docker-compose up ``` to create the container and run it.
4. The application will be available and running on http://localhost:8080/

## Deploying to AWS ECS with Terraform
On your terminal, 
1. Navigate to terraform folder.
2. Run ```terraform init``` to initialize directory, pull down providers.
3. Run ```terraform plan``` to create an execution plan without making changes.
4. Run ```terraform apply``` to deploy infrastructure.

## How to access the application
We configured an outputs.tf file along with an output value called aws_alb.fa-alb.dns_name. After we execute the Terraform apply, to spin up the AWS infrastructure, the load balancer's DNS name will be outputted to the terminal.

We can also run ```terraform output alb.dns_name``` in the terminal, to see our DNS name.
