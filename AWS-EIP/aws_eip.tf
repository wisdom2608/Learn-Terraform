# How to create aws eip and attach it to ec2 instance
provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_eip_association" "example" {
  instance_id   = aws_instance.example.id
  allocation_id = aws_eip.example.id
}
