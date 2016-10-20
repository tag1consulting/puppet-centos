# Class site_selinux::drupal
#
# Selinux contexts for Drupal sites.
class site_selinux::drupal {

 # Allow DB connections.
  selboolean { 'httpd_can_network_connect_db':
    persistent => true,
    value      => on,
  }

  # Allow use of sendmail.
  selboolean { 'httpd_can_sendmail':
    persistent => true,
    value      => on,
  }

  # Allow memcache connections.
  selboolean { 'httpd_can_network_memcache':
    persistent => true,
    value      => on,
  }

  # Set default file contexts for httpd-writable Drupal directories (files/private_files).
  $drupal_file_paths = hiera_hash('site_selinux::drupal::drupal_file_paths', {})
  create_resources('selinux::fcontext', $drupal_file_paths, { context => 'httpd_sys_rw_content_t' })

  # Set default file contexts for httpd-readable paths
  # (static files outside of webroot that apache may need to read).
  $httpd_readable_paths = hiera_hash('site_selinux::drupal::httpd_readable_paths', {})
  create_resources('selinux::fcontext', $httpd_readable_paths, { context => 'httpd_sys_content_t' })

  # Custom httpdsolr selinux module:
  # allow php/httpd/varnishd to access solr network ports.
  selinux::module { 'httpdsolr':
    source => 'puppet:///modules/site_selinux/httpdsolr/httpdsolr.te',
  }

  # Custom httpdvarnish selinux module: allow php/httpd to access varnish control ports.
  selinux::module { 'httpdvarnish':
    source => 'puppet:///modules/site_selinux/httpdvarnish/httpdvarnish.te',
  }

  # Use semanage to assign solr ports to the solr_port_t type
  # which is defined in the httpdsolr selinux module.
  #
  # Assign port tcp/8112 to solr (used for solr 1.x)
  exec { 'semanage-port-8112':
    command => '/usr/sbin/semanage port -a -t solr_port_t -p tcp 8112',
    unless  => '/bin/grep solr_port_t /etc/selinux/targeted/modules/active/ports.local | /bin/grep -q 8112',
    require => Selinux::Module['httpdsolr'],
  }

  # Assign port tcp/8114 to solr (used for solr 4.x).
  exec { 'semanage-port-8114':
    command => '/usr/sbin/semanage port -a -t solr_port_t -p tcp 8114',
    unless  => '/bin/grep solr_port_t /etc/selinux/targeted/modules/active/ports.local | /bin/grep -q 8114',
    require => Selinux::Module['httpdsolr'],
  }

  # Assign port tcp/8115 to solr (used for solr 5.x).
  exec { 'semanage-port-8115':
    command => '/usr/sbin/semanage port -a -t solr_port_t -p tcp 8115',
    unless  => '/bin/grep solr_port_t /etc/selinux/targeted/modules/active/ports.local | /bin/grep -q 8115',
    require => Selinux::Module['httpdsolr'],
  }
}
