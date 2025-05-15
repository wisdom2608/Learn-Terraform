resource "aws_security_group" "devsecops_sg" {
  name        = "Prometheus-Grafana-SG"
  description = "Open 22,443,80,9100,9090,3000"


  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 443, 80, 9100, 9090, 3000] : {
      description      = "DevSecOps-Ports"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "devsecops_sg"
    Env  = "Dev"
  }
}

data "template_file" "prometheus_grafana" {
  template = file("${path.module}/user_data.tpl")

  vars = {
    grafana = file("${path.module}/grafana.sh")
    prometheus = file("${path.module}/prometheus.sh")
  }
}

data "template_file" "node_exporter" {
  template = file("${path.module}/Node-Exporter/user_data.tpl")

  vars = {
    node_exporter = file("${path.module}/Node-Exporter/node_exporter.sh")
    
  }
}



resource "aws_instance" "prometheus_grafana" {
  ami                    = "ami-04f167a56786e4b09" # Ubuntu 20.04
  instance_type          = "t2.micro"
  key_name               = "VM-KP"
  vpc_security_group_ids = [aws_security_group.devsecops_sg.id]
  # user_data              = templatefile("./prometheus_grafana.sh", {})
  user_data     = data.template_file.prometheus_grafana.rendered
  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "Prometheus-Grafana"
    Env  = "Dev"
  }

}

resource "aws_instance" "app_server" {
  ami                    = "ami-04f167a56786e4b09" # Ubuntu 20.04
  instance_type          = "t2.micro"
  key_name               = "VM-KP"
  vpc_security_group_ids = [aws_security_group.devsecops_sg.id]
  user_data     = data.template_file.node_exporter.rendered
  
  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "App-Node-Exporter"
    Env  = "Dev"
  }

}