# true-house-infra

TrueHouse infrastructure

deploy a aws ec2 instance provisioned with

* docker
* docker compose

and ready to deploy `https://github.com/gAmadorH/true-house-be` project
using the `https://hub.docker.com/repository/docker/gamadorh1993/truehouse` image

## requirements

system requirements

* terraform v0.13.5

## run using docker compose

run the the following commands

```bash
git clone https://github.com/gAmadorH/true-house-infra.git
cd true-house-infra
cp terraform.tfvars.example terraform.tfvars
cp terraform_rsa.pub.example terraform_rsa.pub
terraform init
terraform apply
```

in a flew seconds you have a ec2 instance with docker and docker compose
go to instances in aws console and then go to network section for your public ip

## format and quality

```bash
terraform fmt
terraform validate
terraform plan
```
