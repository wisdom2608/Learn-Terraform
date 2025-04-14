terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
 backend "s3" {
    bucket = "my_bucket_name"
    key    = "tf_logs/terraform.state"
    region = "us-east-2"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "TF_LOG_Server"
  }
}

# You have to be inside the tf root directory

# terraform init
# terraform validate

# After terraform init, We've to set TT_LOG env variable: 
# For PowerShell terminal , we do ass follows:

# > $env:TF_LOG="TRACE"
# > $env:TF_LOG_PATH="./terraform.txt"


# For Bash terminal we do the following

# $ export TF_LOG="TRACE"
# $ export TF_LOG_PATH="terraform.txt"
# terraform fmt; terraform apply


