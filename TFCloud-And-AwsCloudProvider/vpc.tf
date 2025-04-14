# resource "aws_vpc" "default" {
#   cidr_block = "default"
#   tags = {
#     Name = "Default"
#   }
# }

data "aws_vpc" "default" {}