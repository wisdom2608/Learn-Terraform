################################################################################
#                    BEFORE LOCAL BLOCK
################################################################################
resource "local_file" "example" {
  count    = 2
  filename = "${path.module}/example_${count.index}.txt"
  content  = "It's good to know terraform local providers.\nI'll 4eva be grateful.\nThanks!!!"
}

resource "local_sensitive_file" "sensitive" {
  filename = "${path.module}/sensitive.txt"
  content  = "This is my new password.\nIt should stay sensitive.\nThis is best practice."
}

################################################################################
#                    AFTER LOCAL BLOCK
################################################################################

locals {
  base_path = "${path.module}/files"
}

resource "local_file" "example" {
  count    = 2
  filename = "${local.base_path}/example_${count.index}.txt"
  content  = "It's good to know terraform local providers.\nI'll 4eva be grateful.\nThanks!!!"
}

resource "local_sensitive_file" "sensitive" {
  filename = "${local.base_path}/sensitive.txt"
  content  = "This is my new password.\nIt should stay sensitive.\nThis is best practice."
}

################################################################################
#                     SPECIAL LOCAL BLOCK
################################################################################


locals {
  environment = "staging" # dev, staging, prod
  upper_case  = upper(local.environment)
  base_path   = "${path.module}/config/${local.upper_case}"
}

resource "local_file" "server" {

  filename = "${local.base_path}/server.sh"
  content  = <<EOT
  environment=${local.environment}
  port=8080
  EOT
}

resource "local_sensitive_file" "sensitive" {
  filename = "${local.base_path}/password.txt"
  content  = "localvariables123!"
}
