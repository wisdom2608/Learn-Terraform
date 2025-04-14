locals {
  tags = {
    Name     = "wisdom"
    Dev_env  = "${var.dev_environment}"
    Prod_env = "${var.prod_environment}"
    Team = "DevOps"
    Purpose ="Monitoring-App"
  }
  key_name = "VM-KP"
  ami      = var.ami
}