#Create EC2 Instance

variable "instance_type" {
  description = "Instance type"
  type        = map(string)
  default = {
    "dev"   = "t2.micro"
    "stage" = "t2.medium"
    "prod"  = "t3.nano"
  }
}
module "EC2" {
  source        = "./modules/EC2"
  ami           = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  key_name      = var.key_name
  env_prefix    = var.env_prefix
  environment   = var.environment
  
}

output "instance-public-ip" {
  value = module.EC2.instance-public-ip
}

output "instance-id" {
  value = module.EC2.instance-id
}

output "instance-az" {
  value = module.EC2.instance-az
}

output "instance-public-dns" {
  value = module.EC2.instance-public-dns
}