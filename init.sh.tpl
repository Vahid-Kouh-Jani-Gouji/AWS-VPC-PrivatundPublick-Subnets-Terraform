#!/bin/bash
set -x
sudo apt update -y
sudo apt install nginx -y
//INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
//echo "Hello from $INSTANCE_IP" > /usr/share/nginx/html/index.html
sudo echo "<h1>Hello from Terraform My IP Address is : $(curl https://ipinfo.io/ip)</h1>" >> /var/www/html/index.html
echo "VPC = ${example}" >> /var/www/html/index.html
echo "Subnet = ${subnet}" >> /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx

