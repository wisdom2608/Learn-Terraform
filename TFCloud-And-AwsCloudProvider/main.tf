
data "aws_availability_zones" "az" {}

resource "aws_instance" "tfc_instance" {
  ami                         = "ami-0fc82f4dabc05670b" #  AL2
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.az.names[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tfc_sg.id]
  key_name                    = "VM-KP"
  tags = {
    Name = "test-instance"

  }
  depends_on = [aws_security_group.tfc_sg]
  user_data = <<EOF
#!/bin/ash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl enable httpd
  echo "<h1>Wisdom Tech</h1>" | sudo tee /var/www/html/index.html
  sudo systemctl start httpd
  EOF
  lifecycle { // resourse lifecyle .
    create_before_destroy = true
    
  }
}

