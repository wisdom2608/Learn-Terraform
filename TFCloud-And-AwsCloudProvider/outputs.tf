output "instance_public_ip" {
  description = "Instance Public IP Address"
  value       = aws_instance.tfc_instance.public_ip
  sensitive   = false
}


output "instance_state" {
  description = "Instance Public IP Address"
  value       = aws_instance.tfc_instance.instance_state
  sensitive   = false
}


output "instance_public_dns" {
  description = "Instance Public IP DNS"
  value       = aws_instance.tfc_instance.public_dns
  sensitive   = false
}