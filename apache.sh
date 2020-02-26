#!/bin/bash
path=/etc/apache2/apache2.conf
sudo apt-get update -y

sudo apt-get install apache2 -y

sudo ufw allow 80
echo "add domain name"
read domain
sudo mkdir -p /var/www/html/$domain
echo  "<html><body><h1>HELLO......!!!! This is MIT....!!!! </h1></body></html>" > /var/www/html/$domain/index.html
sudo chown -Rf www-data:www-data /var/www/html/$domain
sudo chmod -Rf 775 /var/www/html/$domain
echo "<VirtualHost *:80>
        ServerAdmin $domain
        ServerName www.$domain
        DirectoryIndex index.php index.html
        DocumentRoot /var/www/html/$domain
</VirtualHost>" > /etc/apache2/sites-available/$domain.conf

sed -i '175 a\
        <Directory /var/www/html/server.com>\
        Options Indexes MultiViews FollowSymLinks\
        DirectoryIndex index.php index.html\
        AllowOverride all\
        Allow From all\
        </Directory>' $path

sed -i 's/server.com/'$domain/g $path
a2ensite $domain.conf

apache2ctl configtest

systemctl restart apache2

rm /var/www/html/index.html

rm /etc/apache2/sites-available/default-ssl.conf
rm /etc/apache2/sites-available/000-default.conf



