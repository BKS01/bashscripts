#!/bin/bash

# Установка Apache
sudo apt update
sudo apt install -y apache2

# Установка MariaDB
sudo apt install -y mariadb-server

# Установка PHP и необходимых расширений
sudo apt install -y php libapache2-mod-php php-mysql

# Настройка Apache для обработки файлов PHP
sudo sed -i 's/DirectoryIndex.*/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-enabled/dir.conf
sudo systemctl restart apache2

# Генерация пароля для пользователя root базы данных MariaDB
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 12)

sudo mysql <<MYSQL_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Создание базы данных и пользователя для WordPress
WORDPRESS_DB="wordpress"
WORDPRESS_USER="wordpressuser"
WORDPRESS_PASSWORD="password"

sudo mysql <<MYSQL_SCRIPT
CREATE DATABASE $WORDPRESS_DB;
CREATE USER '$WORDPRESS_USER'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD';
GRANT ALL PRIVILEGES ON $WORDPRESS_DB.* TO '$WORDPRESS_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Загрузка и установка WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/

# Настройка прав доступа к файлам WordPress
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Создание виртуального хоста Apache для WordPress
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOT
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/wordpress

    <Directory /var/www/html/wordpress>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

sudo a2dissite 000-default.conf
sudo a2ensite wordpress.conf
sudo systemctl restart apache2

# Настройка wp-config.php
cd /var/www/html/wordpress
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$WORDPRESS_DB/" wp-config.php
sed -i "s/username_here/$WORDPRESS_USER/" wp-config.php
sed -i "s/password_here/$WORDPRESS_PASSWORD/" wp-config.php
sed -i "s/localhost/localhost/" wp-config.php

echo "Установка и настройка WordPress завершены!"
echo "Пароль для пользователя root базы данных MariaDB: $MYSQL_ROOT_PASSWORD"
