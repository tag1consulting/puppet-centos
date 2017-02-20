# Class site_profile::web
#
# Profile class to configure web servers.
#
class site_profile::web {

  # Firewall configuration for web hosts.
  $firewall_rules = lookup('site_profile::web::firewall_rules',
                           { 'value_type'    => 'Hash',
                             'merge'         => 'deep',
                             'default_value' => {},
                           })
  $firewall_provider = lookup('firewall_provider', { 'value_type' => 'String', 'default_value' => 'firewall', })
  create_resources($firewall_provider, $firewall_rules)

  # SELinux configuration for Drupal sites.
  class { 'site_selinux::drupal': }

  # Setup Apache base class, includes default vhost.
  class  { 'apache': }
  # Setup Vhosts.
  $vhost_dir = lookup('apache::vhost_dir', { 'value_type' => 'String', 'default_value' => '/etc/httpd/conf.d', })
  $vhosts = lookup('site_profile::web::vhosts',
                   { 'value_type'    => 'Hash',
                     'merge'         => 'deep',
                     'default_value' => {},
                   })
  create_resources('apache::vhost', $vhosts, { require => File[$vhost_dir], })

  # Create additional directories which need to be writable by apache/php.
  # Note these same directories should also be included in
  # site_selinux::drupal::drupal_file_paths to ensure they have correct selinux contexts.
  $web_writable_dirs = lookup('site_profile::web::apache_writable_dirs',
                              { 'value_type'    => 'Array',
                                'merge'         => 'unique',
                                'default_value' => [],
                              })
  file { $web_writable_dirs:
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => 0755,
    require => Package['httpd'],
  }

  # PHP
  # Setup php.ini.
  $php_ini = lookup('site_profile::web::php_ini',
                    { 'value_type'    => 'Hash',
                      'merge'         => 'deep',
                      'default_value' => {},
                    })
  create_resources('php::ini', $php_ini)

  class { 'php::cli': }
  class { 'php::mod_php5': }

  # Install PHP modules (extensions).
  $php_packages = hiera('site_profile::web::php_packages',
                        { 'value_type'    => 'Array',
                          'merge'         => 'unique',
                          'default_value' => [],
                        })
  $php_pear_packages = hiera('site_profile::web::php_pear_packages',
                             { 'value_type'    => 'Array',
                               'merge'         => 'unique',
                               'default_value' => [],
                             })
  if ($php_packages != []) {
    php::module { $php_packages: }
  }
  if ($php_pear_packages != []) {
    php::module { $php_pear_packages: }
  }

  # Install and configure PHP opcache (either APC or Zend Opcache).
  $opcache_pkg_name = lookup('site_profile::web::php_opcache_packagename',
                             { 'value_type' => 'String',
                               'default_value' => 'php-pecl-apc'
                             })
  php::module { $opcache_pkg_name: }
  case $opcache_pkg_name {
    /opcache/: {
      $opcache_settings = lookup('site_profile::web::php_opcache_ini',
                                 { 'value_type'    => 'Hash',
                                   'merge'         => 'deep',
                                   'default_value' => {},
                                 })
      php::module::ini { 'opcache':
        pkgname  => $opcache_pkg_name,
        prefix   => lookup('site_profile::web::php_opcache_prefix', { 'value_type' => 'String', 'default_value' => '10', }),
        settings => $opcache_settings,
        zend     => true,
      }
    }
    default: {
      $apc_settings = lookup('site_profile::web::php_apc_ini',
                                 { 'value_type'    => 'Hash',
                                   'merge'         => 'deep',
                                   'default_value' => {},
                                 })
      php::module::ini { 'apc':
        pkgname  => $opcache_pkg_name,
        settings => $apc_settings,
      }
    }
  }

  # Memcache module configuration.
  $enable_php_memcache = lookup('site_profile::web::enable_php_memcached',
                                { 'value_type'    => 'Boolean',
                                  'default_value' => true,
                                })
  if ($enable_php_memcache) {
    $php_memcache_packagename = lookup('site_profile::web::php_memcache_packagename',
                                      { 'value_type' => 'String',
                                        'default_value' =>'php-pecl-memcache'
                                      })
    php::module { "$php_memcache_packagename": }
    $memcache_settings = lookup('site_profile::web::php_memcache_ini',
                                 { 'value_type'    => 'Hash',
                                   'merge'         => 'deep',
                                   'default_value' => {},
                                 })
    php::module::ini { 'memcache':
      pkgname  => $php_memcache_packagename,
      prefix   => lookup('site_profile::web::php_memcache_prefix', { 'value_type' => 'String', 'default_value' => '40', }),
      settings => $memcache_settings,
    }
  }

  # Install Drush.
  class { 'yumrepos::drush8': }

  package { 'drush':
    ensure  => latest,
    require => Class['yumrepos::drush8'],
  }

  # Setup memcached.
  $enable_memcached = lookup('site_profile::web::enable_memcached', { 'value_type' => 'Boolean', 'default_value' => true, })
  if ($enable_memcached) {
    class {'memcached': }
  }

}
