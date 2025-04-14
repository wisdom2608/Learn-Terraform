# ==============================
#     Setup TFC Environment
# ==============================

# 1. Create Organization

resource "tfe_organization" "dev_org" {
  name  = "wisdomtech"
  email = "mueatech087@gmail.com"
}

# 2. Create Project
resource "tfe_project" "dev_project" {
  organization = tfe_organization.dev_org.name
  name         = "dev_project"
  depends_on = [ tfe_organization.dev_org ]
}

# 3. Create Workspace
resource "tfe_workspace" "dev_environment" {
  name         = "dev_environment"
  organization = tfe_organization.dev_org.name
}

# 4. Create variable set
resource "tfe_variable_set" "dev_varsets" {
  name         = "varsets"
  description  = "varset for favour organization"
  organization = tfe_organization.dev_org.name
}

# 5a . Attach Varset to workspace

resource "tfe_workspace_variable_set" "dev_varsets_attachment" {
  workspace_id    = tfe_workspace.dev_environment.id
  variable_set_id = tfe_variable_set.dev_varsets.id
}

# 5b. Attach varsets to project
resource "tfe_project_variable_set" "project_varsets_attachment" {
  project_id      = tfe_project.dev_project.id
  variable_set_id = tfe_variable_set.dev_varsets.id
}
# -------------------------------------
#      Create Terraform Variables
#-------------------------------------- 

# 7a. Create Terraform vars
resource "tfe_variable" "region" {
  key             = "region"
  value           = "us-east-2"
  category        = "terraform"
  description     = "aws region variable"
  variable_set_id = tfe_variable_set.dev_varsets.id
}
# 7b. Create another Terraform vars
resource "tfe_variable" "instance_tye" {
  key             = "instance_tye"
  value           = "t2.micro"
  category        = "terraform"
  description     = "aws instance type variable"
  variable_set_id = tfe_variable_set.dev_varsets.id
}


# -------------------------------------
#   Create Environment Variables
#--------------------------------------
# 8a. Create Environment variables 
resource "tfe_variable" "aws_access_key_id" {
  key             = "AWS_ACCESS_KEY_ID"
  value           =  var.AWS_ACCESS_KEY_ID
  category        = "env"
  description     = "aws_access_key_id"
  sensitive       = true
  variable_set_id = tfe_variable_set.dev_varsets.id
}
# 8b. Create Environment variables 
resource "tfe_variable" "aws_secret_access_key_id" {
  key             = "AWS_SECRET_ACCESS_KEY_ID"
  value           = var.AWS_SECRET_ACCESS_KEY_ID
  category        = "env"
  description     = "aws_secret_access_key_id"
  sensitive       = true
  variable_set_id = tfe_variable_set.dev_varsets.id
}


# # 9. Create team
# resource "tfe_team" "team" {
#   name         = "Favour75"
#   organization = tfe_organization.favour_org.name
# }
# # 3. Attach team to workspace

# resource "tfe_team_access" "access" {
#   access       = "read"
#   team_id      = tfe_team.team.id
#   workspace_id = tfe_workspace.favour_workspace.id
# }
