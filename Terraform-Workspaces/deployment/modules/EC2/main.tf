resource "aws_instance" "workspace_instance" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  tags = {
    Name: "${var.env_prefix}-Server"
    Environment: var.environment
  }
  
}
