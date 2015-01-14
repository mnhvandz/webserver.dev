#!/usr/bin/env bash



# update and upgrade on the guest virtual machine
sudo apt-get update
sudo apt-get upgrade -y

# Install apache 2
sudo apt-get install apache2 -y

# enable mod_rewrite
sudo a2enmod rewrite

# enable vhost_alias
sudo a2enmod vhost_alias

# enable vhost_alias
sudo a2enmod status


# TODO setup hosts file


#Install php5 & related modules
sudo apt-get install php5 php5-cli php5-common libapache2-mod-php5 -y
sudo apt-get install mcrypt php5-mcrypt php5-intl php5-adodb php5-gd php-pear -y
sudo apt-get libgd-tools libmcrypt-dev php5-mysql php5-curl -y

#enabling few modules
sudo php5enmod mcrypt adodb gd json intl mcrypt mysqli mysql pdo_mysql

# Password to use fro phpmyadmin and MySql
UniquePassWord='upw'

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $UniquePassWord"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $UniquePassWord"
sudo apt-get -y install mysql-server 

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $UniquePassWord"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $UniquePassWord"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $UniquePassWord"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# restart apache
sudo service apache2 restart 


# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
