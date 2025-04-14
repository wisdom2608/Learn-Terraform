output "instance-public-ip" {
  value = aws_instance.workspace_instance.public_ip
}

output "instance-id" {
    value = aws_instance.workspace_instance.host_id
  
}

output "instance-az" {
  value = aws_instance.workspace_instance.availability_zone
}

output "instance-public-dns" {
  value = aws_instance.workspace_instance.public_dns
}