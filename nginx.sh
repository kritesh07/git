#!/bin/bash
apt update
apt install nginx -y
ufw allow 'Nginx HTTP'
sudo ufw allow 80
echo "add domain name"
read domain
sudo mkdir -p /var/www/html/$domain
echo  "<html><body><h1>HELLO......!!!! This is Nginx ....!!!! </h1></body></html>" > /var/www/html/$domain/index.html

sudo chmod -Rf 775 /var/www/html/$domain
echo "server {
        listen 80;
        listen [::]:80;

        root /var/www/html/$domain;
        index index.html;

        server_name $domain $domain.com;

        location / {
                try_files $uri $uri/ =404;
        }
}" > /etc/nginx/sites-available/$domain.conf

nginx -t

rm /var/www/html/index.nginx-debian.html

rm /etc/nginx/sites-enabled/default  

ln -s /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/

systemctl restart nginx


