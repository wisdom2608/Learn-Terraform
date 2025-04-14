
# Create a GitHub repository
resource "github_repository" "wisdomtech" {
  name        = var.repo_name
  description = "A repository for wisdomtech infrastructure"
  visibility  = "private" # or public

  # Initialize the repository with a README.md (optional)
  auto_init = true

  # Protect the main branch (optional, recommended)
  default_branch = "main"
}

# Create the dev branch
resource "github_branch" "dev" {
  repository    = github_repository.wisdomtech.name
  branch        = "dev"
  source_branch = github_repository.wisdomtech.default_branch
}

# Create the staging branch
resource "github_branch" "staging" {
  repository    = github_repository.wisdomtech.name
  branch        = "staging"
  source_branch = github_repository.wisdomtech.default_branch
}

# Create the prod branch
resource "github_branch" "prod" {
  repository    = github_repository.wisdomtech.name
  branch        = "prod"
  source_branch = github_repository.wisdomtech.default_branch
}

# Optional output to display the repository URL
output "repository_url" {
  value = github_repository.wisdomtech.html_url
}

output "dev_branch_url" {
  value = "${github_repository.wisdomtech.http_clone_url}/tree/dev"
}

output "staging_branch_url" {
  value = "${github_repository.wisdomtech.http_clone_url}/tree/staging"
}

output "prod_branch_url" {
  value = "${github_repository.wisdomtech.http_clone_url}/tree/prod"
}