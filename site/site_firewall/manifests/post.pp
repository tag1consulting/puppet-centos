# Class site_firewall::post
#
# Includes any firewall rules that need to be included
# after standard rules.
#
class site_firewall::post {
  firewall { '999 drop all':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }
}
