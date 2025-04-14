variable "tfe_token" {
  default = "your-tfc-token"
  sensitive = true
}


variable "AWS_ACCESS_KEY_ID" {
  default="you-aws-access-key-id"
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY_ID" {
  default = "your-aws-secret-access-key-id"
  sensitive = true
}