resource "aws_instance" "test" {
    ami = var.ami
    key_name = "test-key"
    instance_type = "t2.micro"
    tags = {
      Name = "Test-instance"
    }
}