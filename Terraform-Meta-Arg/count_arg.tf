variable "instance_name" {
  description = "EC2 instance Name"
  type = list(string)
  default = [ "Web", "App" ]
}

variable "count_instance" {
  default = 3
}
resource "aws_instance" "tes_ec2" {
  ami = ""
  instance_type = ""
  key_name = ""
  availability_zone = ""
  vpc_security_group_ids = ""
  iam_instance_profile = ""
  count = var.count_instance
 

}