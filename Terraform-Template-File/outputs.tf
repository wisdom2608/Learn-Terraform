output "public_ip" {
  value = {
    app_server_ip         = aws_instance.node_exporter.public_ip
    prometheus_grafana_ip = aws_instance.prometheus_grafana.public_ip
  }

}