# LAMP stack development environment quickstart

To start up a LAMP stack virtual machine ready for Drupal 8 development, do the following:

0. Clone your webroot into ```html```:
  * ```git clone git clone --branch 8.0.x http://git.drupal.org/project/drupal.git html```
0. Install optional plugins (this only needs to happen once on your workstation): 
  * ```vagrant plugin install vagrant-triggers && vagrant plugin install vagrant-cachier```
0. Run ```vagrant up``` to start up the virtual machine.  You will be presented with a link at the end of the startup to the virtual machine: 
  * ```==> default: Running triggers after up...

==>  VAGRANT for puppet-centos
http://localhost:6480/```

The link can be re-displayed at any time by running ```vagrant up```
0. Due to a quirk in the way Vagrant syncs folders, you will need to run ```vagrant rsync``` after the initial provisioning is complete to set the webroot file permissions properly. 

A blank database is created automatically.  The database name, username, and password are all "vagrant".

To install Drush 8, run:  ```vagrant ssh -c "sudo /vagrant/scripts/drush8.sh".  Once Drush 8 is installed, you can set up the initial Drupal database by running: ```vagrant ssh -c "cd /var/www/html && drush si -y standard --db-url=mysql://vagrant:vagrant@localhost/vagrant"``` or by using the install.php web UI.

## Other usfeul commands
* ```vagrant halt``` - power off the virtual machine
* ```vagrant suspend``` - hibernate the virtual machine
* ```vagrant up``` - start up the virtual machine, creating it if necessary
* ```vagrant destroy``` - delete the virtual machine and destroy its content
* ```vagrant rsync-auto``` - watch the ```html``` directory and sync any local changes into the virtual machine, most useful when run in the background ```vagrant rsync-auto &```
* ```vagrant rsync``` - do a one-time sync of the html directory
* ```vagrant provision``` - re-run the provisioning scripts, useful when changing the Vagrantfile or puppet/hiera configurations

