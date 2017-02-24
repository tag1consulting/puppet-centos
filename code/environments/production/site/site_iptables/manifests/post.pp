# Class site_iptables::post
#
# Includes any iptables rules that need to be included
# after standard rules.
#
class site_iptables::post {
  firewall { '999 drop all':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }
}
