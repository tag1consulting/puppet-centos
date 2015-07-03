# Class site_iptables::pre
#
# This class ensures a base set of iptables rules
# that should be in place before rules added by other classes/profiles.
#
class site_iptables::pre {
  Firewall {
    require => undef,
  }

  # Default iptables rules
  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    ctstate => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }

}
