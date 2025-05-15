terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "5.16.0"
    }
  }
  backend "s3" {
    bucket = "YourBucketName"
    key    = "devsecops/terraform.tfstate"
    region = "YourRegion"
  }
}
provider "aws" {
  region = "YourRegion"
}
