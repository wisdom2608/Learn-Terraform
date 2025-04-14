# Link: https://registry.terraform.io/providers/hashicorp/tfe/latest

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.64.0"
    }
  }
}

provider "tfe" {
  token = var.tfe_token
  # token =file(~/home/AppData/Roaming/terraform.d/<name_of_the_token.json>)
}

