#!/bin/bash
#path=/etc/apache2/apache2.conf
sudo apt-get update -y

sudo apt-get install apache2 -y
sudo ufw allow 80

apt-get install mysql-server -y
ufw allow 3306/tcp

systemctl start mysql
sudo systemctl enable mysql

sudo apt-get install php -y
apt-get install phpmyadmin -y
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

echo "<VirtualHost *:80>
        ServerAdmin $domain
        ServerName www.$domain
        DirectoryIndex index.php index.html
        DocumentRoot /var/www/html/$domain
</VirtualHost>" > /etc/apache2/sites-available/$domain.conf

#sed -i '175 a\
#        <Directory /var/www/html/server.com>\
#        Options Indexes MultiViews FollowSymLinks\
#        DirectoryIndex index.php index.html\
#        AllowOverride all\
#        Allow From all\
#        </Directory>' $path

#sed -i 's/server.com/'$domain/g $path
a2ensite $domain.conf

rm /var/www/html/index.html

rm -rf /etc/apache2/sites-available/default-ssl.conf

apache2ctl configtest

systemctl restart apache2





