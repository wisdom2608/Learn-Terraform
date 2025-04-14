
terraform {
  required_version = "~> 0.1" # check the latest version in tfc
  cloud {
    hostname = "app.terrafom.io"
    organization = "your_org_name"

    workspaces {
      name = "your_workspace_name"
    }
  }
}

provider "aws" {
  region = var.region
}