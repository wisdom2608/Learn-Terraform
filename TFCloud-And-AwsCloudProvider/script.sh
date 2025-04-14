#!/bin/ash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl enable httpd
echo "<h1>Wisdom Tech</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start httpd

# echo "<h1>Wisdom Tech</h1>" >> /var/www/html/index.html
