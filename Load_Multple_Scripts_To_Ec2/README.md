## How To Load Multiple Scripts To EC2 instance Using Terraform
🔹 These scripts will run automatically when an EC2 instance boots for the first time.

Please read carefully, and then pratice the **example** that follows.

## 💡 A. EXPLANATION
✅ Directory Structure. You can change it as per your requirement.
```bash
terraform-project/
│
├── main.tf                  # Your main Terraform file
├── script1.sh               # Script 1 (must exist here)
├── script2.sh               # Script 2 (must exist here)
├── user_data.tpl            # User data template file
```
- `terraform-project/`: This is the directory which `main.tf`, `scritp1.sh`, `script2.sh`, and `user_data.tpl` are located.
- `user_data.tpl`: This the file that defines the format in which the scripts will be executed.

```bash
#!/bin/bash
cat <<'EOF1' > /home/ubuntu/script1.sh
${script1}
EOF1

cat <<'EOF2' > /home/ubuntu/script2.sh
${script2}
EOF2

chmod +x /home/ubuntu/script1.sh /home/ubuntu/script2.sh

/home/ubuntu/script1.sh
/home/ubuntu/script2.sh

```
- `scritp1.sh`: The file that contains first script.

```bash
sudo apt update -y
sudo apt ...

```
- `script2.sh`: The file for the second script.
```bash
sudo apt update -y
sudo apt ...
```

- `main.tf`: This is the file where resources to be created by terraform are configured.
```bash

data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")

  vars = {
    script1 = file("${path.module}/script1.sh")
    script2 = file("${path.module}/script2.sh")
    #script3 = .... 
  }
}

resource "aws_instance" "server" {
  ami           = "ami-xxxxxxxxx"
  instance_type = "t2.micro"
  user_data     = data.template_file.user_data.rendered
}

```
This block uses Terraform’s `template_file` data source to dynamically generate the content that will be passed as the EC2 instance's user data script.

The `file("${path.module}/script1.sh")` and `file("${path.module}/script2.sh")` both work perfectly. The `path.module` refers to the directory where the current `.tf` file is located. 

The EC2 instance, when launched, will:
 - Save `script1.sh` and `script2.sh` to disk.
 - Make them executable.
 - Run them in order.

❌ If They're in a Different Folder
If our scripts are inside a `scripts/` folder, for example:

```bash
terraform-project/
├── main.tf
├── user_data.tpl
└── scripts/
    ├── script1.sh
    └── script2.sh
```

Then we'd need to change our Terraform code to:
```bash
vars = {
  script1 = file("${path.module}/scripts/script1.sh")
  script2 = file("${path.module}/scripts/script2.sh")
}
```

## ✅ B. EXAMPLE: 
Let's install **node_exporter**, and **prometheus** on the same Ec2 Instance, and then **Node_Exporter** on another instance. At the moment of writing, the version of:
 - prometheus is 3.3.1.
 - grafana is 12.0.0.
 - node_exporter is 12.0.0.
This may change in the future or in the moment you are reading this article.



✅ **Directory Structure**
```bash
Load_Multiplt_Scripts-EC2/
│
├── main.tf                  
├── prometheus.sh          
├── grafana.sh               
├── user_data.tpl            
├── Node-Exporter
     ├── user_data.tpl
     ├── node_exporter.sh             
```
a). **prometheus.sh**
```bash
#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo hostnamectl set-hostname prometheus
/bin/bash
sudo apt install -y wget 

sudo wget https://github.com/prometheus/prometheus/releases/download/v3.3.1/prometheus-3.3.1.linux-amd64.tar.gz
sudo tar -xvf prometheus-3.3.1.linux-amd64.tar.gz
sudo rm -rf prometheus-3.3.1.linux-amd64.tar.gz
cd prometheus-3.3.1.linux-amd64
./prometheus &

```
b). **node_exporter.sh** 
```bash
sudo apt update -y
sudo wget https://dl.node_exporter.com/enterprise/release/node_exporter-enterprise-12.0.0.linux-amd64.tar.gz
sudo tar -zxvf node_exporter-enterprise-12.0.0.linux-amd64.tar.gz
sudo rm -rf node_exporter-enterprise-12.0.0.linux-amd64.tar.gz
cd node_exporter-v12.0.0/
sudo ./bin/node_exporter-server &
```
c). **user_data.tpl** for **node_exporter**, and **prometheus** EC2 instance.
```bash
#!/bin/bash
cat <<'EOF1' > /home/ubuntu/node_exporter.sh
${node_exporter}
EOF1

cat <<'EOF2' > 
${prometheus}
EOF2

chmod +x /home/ubuntu/node_exporter.sh 

/home/ubuntu/node_exporter.sh

```
d). **node_exporter.sh** 
```bash
#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo hostnamectl set-hostname app-nodeex
/bin/bash
sudo apt install -y wget 

wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
sudo tar -xvf node_exporter-1.9.1.linux-amd64.tar.gz
sudo rm -rf node_exporter-1.9.1.linux-amd64.tar.gz
cd node_exporter-1.9.1.linux-amd64
./node_exporter &
```
e). **user_data.tpl** for **node_exporter** EC2 instance.
```bash
#!/bin/bash
cat <<'EOF' > /home/ubuntu/node_exporter.sh
${node_exporter}
EOF

chmod +x /home/ubuntu/node_exporter.sh 

/home/ubuntu/node_exporter.sh

```
f). **main.tf** for the resources to be created. 

```bash
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
    Env  = "dev"
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
  ami                    = "ami-xxxxxxxx" # Ubuntu 20.04
  instance_type          = "t2.micro"
  key_name               = "VM-KP"
  vpc_security_group_ids = [aws_security_group.devsecops_sg.id]
  user_data     = data.template_file.prometheus_grafana.rendered
  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "Prometheus-Grafana-Sever"
    Env  = "dev"
  }
}

resource "aws_instance" "node_exporter" {
  ami                    = "ami-xxxxxxxx" # Ubuntu 20.04
  instance_type          = "t2.micro"
  key_name               = "VM-KP"
  vpc_security_group_ids = [aws_security_group.devsecops_sg.id]
  user_data     = data.template_file.node_exporter.rendered
  
  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "Node-Exporter-Server"
    Env  = "dev"
  }
}
```




