# INSTALLING GRAFANA

# 1. Updetes the system packages
sudo apt update -y

# 2. Install the prerequisite packages:
sudo wget https://dl.grafana.com/enterprise/release/grafana-enterprise-12.0.0.linux-amd64.tar.gz
sudo tar -zxvf grafana-enterprise-12.0.0.linux-amd64.tar.gz
sudo rm -rf grafana-enterprise-12.0.0.linux-amd64.tar.gz
cd grafana-v12.0.0/
sudo ./bin/grafana-server &


# # Starts the Grafana server
# sudo /bin/systemctl daemon-reload
# sudo /bin/systemctl enable grafana-server
# sudo /bin/systemctl start grafana-server
# sudo /bin/systemctl status grafana-server.service


# Grafana runs on port 3000