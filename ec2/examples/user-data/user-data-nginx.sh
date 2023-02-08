#!/bin/bash
yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl start nginx
sudo systemctl enable nginx
INTERFACE=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNETID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/subnet-id)
sudo sed -i "s/<h2>Website Administrator<\/h2>/<h2>Website Administrator - Subnet Id -> $SUBNETID<\/h2>/" /usr/share/nginx/html/index.html
