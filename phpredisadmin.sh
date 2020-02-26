#!/bin/bash
apt update
apt-get install redis -y
systemctl start redis-server
systemctl enable redis-server
apt-get install apache2 -y
apt-get install php -y
apt-get install php-redis -y
apt-get install php7.2-mbstring -y
apt-get install php7.2-dev -y

git clone https://github.com/ErikDubbelboer/phpRedisAdmin.git
cd phpRedisAdmin

git clone https://github.com/nrk/predis.git vendor
cd includes/
cp config.sample.inc.php config.inc.php
cd
mv phpRedisAdmin /var/www/html
 
chown -Rf www-data /var/www/html/phpRedisAdmin/
chmod -Rf 775 /var/www/html/phpRedisAdmin/
echo "<VirtualHost *:80>
ServerAdmin root@example.com
DocumentRoot /var/www/html/phpRedisAdmin/
<Directory /var/www/html/phpRedisAdmin/>
Options FollowSymLinks
AllowOverride All
</Directory>
</VirtualHost>" > /etc/apache2/sites-available/phpRedisAdmin.conf

a2ensite phpRedisAdmin.conf
apache2ctl configtest


systemctl restart apache2
echo "navigate to http://server-ip/phpRedisAdmin"