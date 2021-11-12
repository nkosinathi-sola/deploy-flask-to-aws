### Source Code Structure

```bash

├── Dockerfile
├── app
│   ├── app.py
│   └── requirements.txt           
└── terraform                       
    ├── alb.tf 
    ├── main.tf
    ├── network.tf 
    ├── outputs.tf
    ├── providers.tf  
    └── variables.tf         
```

### Prerequisites
Docker
Terraform
AWS account
AWS profile

### How to run the application with Docker
On your terminal, 
1. Navigate to the root direcory of the project.
2. Run ```docker build . -t deploy_flask``` to build a new image from the source code.
3. Run ```docker run -p 5000:5000 -t -i deploy_flask:latest``` to create the container and run it.
4. The application will be available and running on http://localhost:5000/

### Deploying to AWS ECS with Terraform
On your terminal, 
1. Navigate to terraform folder.
2. Run ```terraform init``` to initialize directory, pull down providers.
3. Run ```terraform plan``` to create an execution plan without making changes.
4. Run ```terraform apply``` to deploy infrastructure.

### How to access the application
In our ```outputs.tf``` file, we have ```aws_alb.fa-alb.dns_name``` as an output.
So we can run ```terraform output alb.dns_name``` in the terminal, to see our ECS dns name.