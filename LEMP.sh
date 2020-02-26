#!/bin/bash
apt update

apt install nginx -y


ufw allow 'Nginx HTTP'

sudo ufw allow 80

apt-get install mysql-server -y

ufw allow 3306/tcp

systemctl start mysql

sudo systemctl enable mysql


 mysql_secure_installation



 
echo "THIS IS FOR TESTING PURPOSE" 
 echo "username"
 read username
 echo "password"
 read password
 echo "database"
read database

mysql  <<-ENDMARKER

create user '$username'@'localhost' identified by '$password'; 

GRANT ALL PRIVILEGES  ON *.* TO '$username'@'localhost';

create database $database;    

ENDMARKER

apt install php-fpm php-mysql -y

systemctl start php7.2-fpm



echo "add domain name"
read domain

sudo mkdir -p /var/www/html/$domain

echo  "<html><body><h1>HELLO......!!!! This is Nginx ....!!!! </h1></body></html>" > /var/www/html/$domain/index.html



sudo chmod -Rf 775 /var/www/html/$domain

echo "server {
listen 80;
root /var/www/html/$domain;
index index.php index.html;
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


rm /var/www/html/index.nginx-debian.html

rm /etc/nginx/sites-enabled/default  

ln -s /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/

nginx -t 

apt-get install phpmyadmin -y




ln -s /usr/share/phpmyadmin /var/www/html/$domain

systemctl restart nginx