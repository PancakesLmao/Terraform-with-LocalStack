# Running Terraform with Localstack

> #### Notice: *LocalStack emulates AWS services locally. However, it is not a full AWS replacement. For example, EC2 is only simulated as metadata (no real VM is created), and S3 does not provide real public web hosting like AWS.*
# Prerequisites
- Localstack Account (for token)
- AWS CLI v2
- Docker
- Terraform

# Folder structure
```
Terraform-with-LocalStack/
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── user_data.sh
│
└── <you_app_name>/
    ├── backend/
    │   ├── Dockerfile
    └── frontend/
	│	└── dist/
```

# Setup
# Configure AWS CLI (fake credentials for LocalStack)
```
aws configure
> AWS ACCESS_KEY: test
> AWS SECRET_ACCESS_KEY: test
> Default region name: us-east-1
> Default output format: json
```

# Setup LocalStack
## Get Localstack Token
Create a Localstack Account then go to https://app.localstack.cloud/getting-started and copy the token
## Start LocalStack
### Options A: Docker run
```
docker run -d -p 4566:4566 -e LOCALSTACK_AUTH_TOKEN=<token> localstack/localstack
```
### Option B: Docker Compose
Store your `LOCALSTACK_AUTH_TOKEN` in an .env file and run docker compose
```
docker compose up --build -d
```
## Verify LocalStack is running
```
docker ps
docker logs <container_id>
```
## Initialize Terraform
```
cd terraform
terraform init
terraform validate
```
## Plan and review changes
```
terraform plan -out=tfplan
```
## Apply Changes
```
terraform apply "tfplan"
```
## Destroy Resources
```
terraform destroy
```

## Stop Localstack
```
docker stop <localstack>
docker rm <localstack>
```

## Checking
```
aws --endpoint-url=http://127.0.0.1:4566 s3 ls  
# If this show up: 2026-04-02 23:02:24 <s3-name>  
# Then you are good
```
Try access it via `http://localhost:4566/<s3-name>`
> Note: *This is not real S3 web hosting. It only simulates object storage behavior.*
