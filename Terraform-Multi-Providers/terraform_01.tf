terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {

  region = "us-east-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

# *************************************************************
#           Create An EC2 instance in different regions
# *************************************************************


/*
Create an ec2 instance in us-east-2 */


resource "aws_instance" "prod-instance" {
  ami           = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  tags = {
    Name = "Prod"
  }
}


/*
Create an ec2 instance in virginia */

resource "aws_instance" "preprod-instance" {
  ami           = "ami-084568db4383264d4"
  provider      = aws.virginia
  instance_type = "t2.micro"
  tags = {
    Name = "PreProd"
  }
}