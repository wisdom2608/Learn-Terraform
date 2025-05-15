terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "5.16.0"
    }
  }
  backend "s3" {
    bucket = "terraform-wisdom2608"
    key    = "devsecops/terraform.tfstate"
    region = "us-east-2"
  }
}
provider "aws" {
  region = "us-east-2"
}
