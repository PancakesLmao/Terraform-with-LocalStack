# Running Terraform with Localstack
# Prerequisites
- Localstack
- AWS CLI v2
- Docker

# Folder structure
root/
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── user_data.sh
│
└── Pankeki-Express/
    ├── backend/
    │   ├── Dockerfile
    │   └── .env
    └── frontend/
	└── dist/
# Setup
# Configure fake AWS account for localstack
```
aws configure
> ACCESS_KEY: test
> SECRET_KEY: test
> Region: us-east-1
> Ouput format: json

# Instruction
## Get Localstack Token
Create a Localstack Account then go to "https://app.localstack.cloud/getting-started" and copy the token
## Start LocalStack
```
docker run -d -p 4566:4566 -e LOCALSTACK_AUTH_TOKEN=<token> localstack/localstack
```
## Verify Localstack is running
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
## Plan
```
terraform plan -out=tfplan
```
## Apply
```
terraform apply "tfplan"
```
## Destroy
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
If this show up: 2026-04-02 23:02:24 <s3-name>  
Then you are good
```
