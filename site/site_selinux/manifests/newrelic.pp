# Class site_selinux::newrelic
#
# Selinux contexts for web servers running newrelic.
class site_selinux::newrelic {

  # Custom newrelic selinux module: allow newrelic to block_suspend and write out newrelic logs.
  selinux::module { 'newrelic':
    source => 'puppet:///modules/site_selinux/newrelic/newrelic.te',
  }

}
