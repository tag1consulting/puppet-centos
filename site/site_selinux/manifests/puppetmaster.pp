# Class site_selinux::puppetmaster
#
# Selinux contexts for a Puppet master server running under apache+passenger.
class site_selinux::puppetmaster {

  # Custom puppetmaster selinux module: allow passenger/httpd to access puppet.
  selinux::module { 'puppetmaster':
    source => 'puppet:///modules/site_selinux/puppetmaster/puppetmaster.te',
  }

  # Set default file contexts for local git clones used by puppet
  # e.g. infra_private and hiera_private which aren't stored directly in /etc/puppet
  $puppet_etc_t_file_paths = hiera_hash('site_selinux::puppetmaster::puppet_etc_t_file_paths', {})
  create_resources('selinux::fcontext', $puppet_etc_t_file_paths, { context => 'puppet_etc_t' })

}
