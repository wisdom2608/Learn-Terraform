
resource "aws_security_group" "tfc_sg" {
  name        = "Tfc-SGs"
  description = "Security Group For HTTP and SSH Access"
  vpc_id      = data.aws_vpc.default.id # aws_vpc.default.id

  ingress {
    description = "Enable SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Enable HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Test-SG"
  }
}