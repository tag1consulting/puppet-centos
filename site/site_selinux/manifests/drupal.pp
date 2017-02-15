# Class site_selinux::drupal
#
# Selinux contexts for Drupal sites.
class site_selinux::drupal {

  # Set SELinux Booleans as specified in hiera.
  $drupal_selbooleans = hiera_hash('site_selinux::drupal::selbooleans', {})
  create_resources('selinux::boolean', $drupal_selbooleans)

  # Set default file contexts for httpd-writable Drupal directories (files/private_files).
  $drupal_file_paths = hiera_hash('site_selinux::drupal::drupal_file_paths', {})
  create_resources('selinux::fcontext', $drupal_file_paths, { context => 'httpd_sys_rw_content_t' })

  # Set default file contexts for httpd-readable paths
  # (static files outside of webroot that apache may need to read).
  $httpd_readable_paths = hiera_hash('site_selinux::drupal::httpd_readable_paths', {})
  create_resources('selinux::fcontext', $httpd_readable_paths, { context => 'httpd_sys_content_t' })

  # Install custom SELinux modules as defined in hiera.
  $drupal_selinux_modules = hiera_hash('site_selinux::drupal::selinux_modules', {})
  create_resources('selinux::module', $drupal_selinux_modules)

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
