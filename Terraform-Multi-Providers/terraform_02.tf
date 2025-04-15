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
  region = "us-west-2"
  alias  = "west"
}

variable "ami" {
  type = map(any)
  default = {
    west    = "ami-beab831bb" # AMI COPIED FROM US-WEST-2 REGION
    us-east = "ami-04f167a56" # AMI COPIED FROM US-EAST-2 REGION
  }
}

variable "subnet_id" {
  type = map(any)
  default = {
    west    = "subnet-32e34" # SUBNET ID COPIED FROM US-WEST-2 REGION
    us-east = "subnet-8067c" # SUBNET ID COPIED FROM US-EAST-2 REGION
  }
}

variable "instance_type" {
  type = map(any)
  default = {
    west    = "t2.micro"
    us-east = "t3.small"
  }
}

resource "aws_instance" "west" {
  provider      = aws.west
  ami           = var.ami.west
  instance_type = var.instance_type.west
  subnet_id     = var.subnet_id.west
  tags = {
    Name = "OREGON-SERVER"
  }
}

resource "aws_instance" "east" {
  ami           = var.ami.us-east
  instance_type = var.instance_type.us-east
  subnet_id     = var.subnet_id.us-east
  tags = {
    Name = "US-EAST"
  }
}
