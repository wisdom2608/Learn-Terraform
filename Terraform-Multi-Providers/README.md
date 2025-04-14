# Terraform Multi Providers

When we have multiple providers in the same configurations, we set `alias` in one of the different providers block so as not to get terraform confused when interacting with the required cloud environment. For example.


Terraform Block

```bash
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

```

Providers in different aws regions

- Provider in us-east-2

```bash
provider "aws" {

region = "us-east-2"
}
```
- provider in us-east-1

```bash
provider "aws" {
alias = "virginia"
region = "us-east-1"
}
```



# *************************************************************
#           Create An EC2 instance in different regions
# *************************************************************


/*
Create an ec2 instance in us-east-2 */

```bash
resource "aws_instance" "prod-instance" {
  ami           = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  tags = {
    Name = "Prod"
  }
}
```


/*
Create an ec2 instance in virginia */

```bash
resource "aws_instance" "preprod-instance" {
  ami           = "ami-084568db4383264d4"
  provider      = aws.virginia  # Provider argument in the instance resource block
  instance_type = "t2.micro"
  tags = {
    Name = "PreProd"
  }
}
```

To create an ec2 in virginia, we must use the provider argument withing the ec2 resource block to be deployed in virginia. 