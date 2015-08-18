#!/bin/sh

if [ ! -f /usr/local/bin/composer ]
  then curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
fi

if [ ! -f /home/vagrant/.composer/vendor/bin/drush ]
  then sudo -u vagrant composer global require drush/drush:dev-master
fi

if ! grep ".composer/vendor" /home/vagrant/.bashrc
  then echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> /home/vagrant/.bashrc
fi
