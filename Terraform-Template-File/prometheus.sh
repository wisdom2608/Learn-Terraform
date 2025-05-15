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



