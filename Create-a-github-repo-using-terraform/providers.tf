terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}


#-----------------------------

# # Configure the GitHub provider
# terraform {
#   required_providers {
#     github = {
#       source  = "integrations/github"
#       version = "~> 5.0" # or latest
#     }
#   }
# }

