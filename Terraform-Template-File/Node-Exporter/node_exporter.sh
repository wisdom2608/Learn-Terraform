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

