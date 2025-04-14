#Create EC2 instance in Public Subnet 2a
resource "aws_instance" "web-1" {
  ami           = local.ami # AL2  AMI
  instance_type = "t2.micro"
  key_name      = local.key_name
  tags = {
    Name = "${local.tags.Name}-Prod"
    Env : "${local.tags.Prod_env}"
    Team: local.tags.Team
    Purpose: local.tags.Purpose
  }
}

resource "aws_instance" "web-2" {
  ami           = local.ami # AL2  AMI
  instance_type = "t2.nano"
  key_name      = local.key_name
  tags = {
    Name = "${local.tags.Name}-Dev"
    Env : "${local.tags.Dev_env}"
    Team: local.tags.Team
    Purpose: local.tags.Purpose
  }
}