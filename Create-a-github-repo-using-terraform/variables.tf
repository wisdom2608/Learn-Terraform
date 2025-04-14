variable "github_token" {
  type        = string
  description = "Github Token"
}

variable "github_owner" {
  type    = string
  default = "wisdom2608"
}

variable "repo_name" {
  type        = string
  default     = "wisdomtech"
  description = "Name of the GitHub repository"
}
