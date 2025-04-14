terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
region = "us-east-2"
}

provider "aws" {
region = "us-west-2"
alias = "west"
}

variable "ami" {
    type = map
    default = {
        west = "XXXXX"       # AMI COPIED FROM US-WEST-2 REGION
        us-east = "xxxx"     # AMI COPIED FROM US-EAST-2 REGION
    }
}

variable "subnet_id" {
    type = map
    default = {
        west = "XXXXX"    # SUBNET ID COPIED FROM US-WEST-2 REGION
        us-east = "xxxx"  # SUBNET ID COPIED FROM US-EAST-2 REGION
    }
}

variable "instance_type" {
    type = map
    default = {
        west = "t2.micro" 
        us-east = "t3.small"
    }
}

resource "aws_instance" "west" {
  provider      = aws.west
  ami           = var.ami.west
  instance_type = var.instance_type.west
  subnet_id     = var.subnet_id.west
  tags = {
    Name = "USA-SERVER"
  }
}

resource "aws_instance" "west" {
  ami           = var.ami.us-east
  instance_type = var.instance_type.us-east
  subnet_id     = var.subnet_id.us-east
  tags = {
    Name = "US-EAST"
  }
}
