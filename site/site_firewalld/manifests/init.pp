# Class for EL7 firewalld configuration.
# Generally rules are applied from directly within modules which require them.
# This class pulls in the 3rd party firewalld module to ensure
# the firewalld package and service are in place.

class site_firewalld {
  $enable_firewall = hiera('enable_firewall', TRUE)
  if ($enable_firewall) {
    require firewalld
  }
}
