# Class site_profile::vagrant
#
# Vagrant-specific profile class.
#
class site_profile::vagrant {

  # Vagrant additions to sudoers - otherwise vagrant can't do anything.
  sudo::conf { 'vagrant':
    content => 'vagrant ALL=(ALL) NOPASSWD: ALL',
  }
  sudo::conf { 'vagrant notty':
    content => 'Defaults:vagrant !requiretty',
  }


}
