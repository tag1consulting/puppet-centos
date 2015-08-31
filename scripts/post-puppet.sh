#!/bin/sh

# Install Drush 8
/vagrant/scripts/drush8.sh 2>&1 > /dev/null

# Ensure Drupal can write settings and files
#chown -R apache /var/www/vagrant-multi1.tag1consulting.com/sites/default
