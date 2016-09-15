#!/bin/sh

# We need some devel stuff
sudo yum install -q -y composer php56u-devel openssl-devel 2>&1 > /dev/null

# Even through it's already installed, we need to install using pecl
sudo pecl install mongodb 2>&1 > /dev/null

# Temporarily set it to mongodb.so
# Yes, I know it'll be replaced by the next provision, but this is only to make composer run once
sudo sed -i.bak -e s/mongo.so/mongodb.so/g /etc/php.d/50-mongo.ini

# Perms are wrong
if [ ! -d /var/www/xhgui/vendor ];
  then 
    sudo mkdir /var/www/xhgui/vendor
fi
sudo chown vagrant:vagrant /var/www/xhgui/vendor
sudo chmod 0777 /var/www/xhgui/cache

# Now composer should run
cd /var/www/xhgui
sudo -u vagrant composer install

echo "xhgui is now available at http://vagrant-xhgui.tag1consulting.com" 
