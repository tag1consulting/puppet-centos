# LAMP stack development environment quickstart

To start up a LAMP stack virtual machine ready for Drupal 8 development, do the following:

0. Clone this repository to a convenient locaion.
0. ```cd``` into the repository and clone your webroot into ```html```:
  * ```cd puppet-centos && git clone --branch 8.0.x http://git.drupal.org/project/drupal.git html```
0. Install optional plugins (this only needs to happen once on your workstation): 
  * ```vagrant plugin install vagrant-triggers && vagrant plugin install vagrant-cachier```
0. Run ```vagrant up``` to start up the virtual machine.  You will be presented with a link at the end of the startup to the virtual machine: 
```
==> default: Running triggers after up...

==> default: Build complete for puppet-centos
==> default: http://localhost:6480/
```

The link can be re-displayed at any time by running ```vagrant up```

A blank database is created automatically.  The database name, username, and password are all "vagrant".

To install Drush 8, run:  ```vagrant ssh -c "sudo /vagrant/scripts/drush8.sh"```

You can set up the initial Drupal database using the install.php web UI or drush.

## Other useful commands
* ```vagrant halt``` - power off the virtual machine
* ```vagrant suspend``` - hibernate the virtual machine
* ```vagrant up``` - start up the virtual machine, creating it if necessary
* ```vagrant destroy``` - delete the virtual machine and destroy its content
* ```vagrant rsync-auto``` - watch the ```html``` directory and sync any local changes into the virtual machine, most useful when run in the background ```vagrant rsync-auto &```
* ```vagrant rsync``` - do a one-time sync of the html directory
* ```vagrant provision``` - re-run the provisioning scripts, useful when changing the Vagrantfile or puppet/hiera configurations

