#!/bin/bash
apt update
apt install nginx -y
ufw allow 'Nginx HTTP'
apt install mariadb-server mariadb-client -y
apt install php-fpm php-mysql -y
apt install phpmyadmin -y

systemctl start php7.2-fpm

mysql_secure_installation

echo "



ADD YOUR DATABASES NAME, USERNAME AND PASSWORD FOR WORDPRESS



" 
 echo "database"
read database
 echo "username"
 read username
 echo "password"
 read password
 



 mysql  <<-ENDMARKER
 
create database $database;

create user '$username'@'localhost' identified by '$password'; 

GRANT ALL PRIVILEGES  ON $database.* TO '$username'@'localhost';

FLUSH PRIVILEGES;

 
ENDMARKER


echo "add your domain name"
read domain
cd /var/www/html/
wget -c http://wordpress.org/latest.zip
apt install unzip -y
unzip latest.zip
mv wordpress $domain
rm latest.zip
sudo chown -Rf www-data:www-data /var/www/html/$domain
sudo chmod -Rf 775 /var/www/html/$domain
cd $domain
mv wp-config-sample.php wp-config.php
sed -i -e 's/database_name_here'/$database/g wp-config.php
sed -i -e 's/username_here'/$username/g wp-config.php
sed -i -e 's/password_here'/$password/g wp-config.php


echo "server {
listen 80;
root /var/www/html/$domain;
index index.php index.html index.htm index.nginx-debian.html;
server_name $domain www.$domain;

location / {
try_files $uri $uri/ =404;
}

location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
}

location ~ /\.ht {
deny all;
}
}" > /etc/nginx/sites-available/$domain.conf

rm /etc/nginx/sites-enabled/default  

ln -s /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/

ln -s /usr/share/phpmyadmin /var/www/html/$domain/

rm /var/www/html/index.html

nginx -t 

systemctl restart nginx




