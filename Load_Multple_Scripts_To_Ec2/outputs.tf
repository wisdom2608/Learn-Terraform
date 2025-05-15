output "public_ip" {
  value = {
    app_server_ip         = aws_instance.app_server.public_ip
    prometheus_grafana_ip = aws_instance.prometheus_grafana.public_ip
  }

}