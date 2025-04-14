# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = "us-east-2"
}

provider "random" {}

resource "random_pet" "name" {}

resource "aws_instance" "web" {
  ami           = "ami-0c11a84584d4e09dd"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
  # user_data              = file("init-script.sh")
  availability_zone      = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids = [aws_security_group.provisioner_sg.id]

  tags = {
    Name = random_pet.name.id
  }
}


resource "aws_key_pair" "my_key" {
  key_name   = "key"
  public_key = file("~/.ssh/my_key.pub")
}


data "aws_availability_zones" "available" {}


resource "null_resource" "terraform_provisioners" {
  depends_on = [aws_instance.web]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/my_key")
    host        = aws_instance.web.public_ip # or host = aws_instance.file_provisioner.public_dns 
  }

  provisioner "file" {
    source      = "./init-script.sh"
    destination = "/home/ec2-user/init-script.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod a+x init-script.sh",
    "bash ./init-script.sh"]
  }
}



