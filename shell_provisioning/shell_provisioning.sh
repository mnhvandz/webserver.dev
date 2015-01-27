#!/usr/bin/env bash

# update and upgrade on the guest virtual machine
echo "Updating ..."
sudo apt-get update 
echo "Upgrading ..."
sudo apt-get upgrade -y 


# Install apache 2
echo "Installing apache2 ..."
sudo apt-get install apache2 -y 

# enable mod_rewrite
echo "Enabling rewrite mode for apache2 ..."
sudo a2enmod rewrite 
 
echo "Enabling vhost_alias for apache2 ..."
# enable vhost_alias
sudo a2enmod vhost_alias 


# Password to use fro phpmyadmin and MySql
UniquePassWord='upw'

echo "Installing MySql ..."
# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $UniquePassWord"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $UniquePassWord"
sudo apt-get -y install mysql-server  


# Note: Since the MySQL bind-address has a tab cahracter I comment out the end line
sudo sed -i 's/bind-address/bind-address = 0.0.0.0#/' /etc/mysql/my.cnf

#mysql -u root -p "upw" -Bse "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'upw' WITH GRANT OPTION;"
sudo service mysql restart


echo "Install various software ..."
sudo apt-get install libgd-tools -y 
sudo apt-get install libmcrypt-dev -y 


# Installing PHP & related modules
echo "Install PHP & related modules ..."
sudo apt-get install libapache2-mod-php5 -y 
sudo apt-get install php5 -y 
sudo apt-get install php5-cli -y 
sudo apt-get install php5-common -y 
sudo apt-get install php5-dev -y 
sudo apt-get install php5-gd -y 
sudo apt-get install php5-json -y 
sudo apt-get install php5-pgsql -y 
sudo apt-get install php5-sqlite -y 
sudo apt-get install php5-memcached -y 
sudo apt-get install php-pear -y 
sudo apt-get install php5-adodb -y 
sudo apt-get install php5-curl -y 
sudo apt-get install php5-intl -y 
sudo apt-get install php5-mcrypt -y 
sudo apt-get install php5-tidy -y 
sudo apt-get install php5-readline -y 
sudo apt-get install php5-mysql -y 
sudo apt-get install php5-xdebug -y 


# Enabling modules
echo "Enabling PHP modules ..."
sudo php5enmod mcrypt adodb gd json intl mcrypt mysqli mysql pdo_mysql 

echo "Installing PhpMyAdmin ..."
# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $UniquePassWord"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $UniquePassWord"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $UniquePassWord"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin 

# restart apache
echo "Disable default vhost..."
sudo a2dissite 000-default.conf

# restart apache
echo "Restart Apache2..."
sudo service apache2 restart  

# install git
echo "Installing Git ..."
sudo apt-get -y install git 

# install Composer
echo "Installing Composer ..."
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

#Install composer-plugins
echo "installing composer-asset-plugin needed to install Yii2"
composer global require "fxp/composer-asset-plugin:1.0.0-beta4"

echo "Executing autoremove ..."
sudo apt-get autoremove -y 

sudo updatedb


