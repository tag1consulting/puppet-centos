# Class site_profile::web
#
# Profile class to configure web servers.
#
class site_profile::web {

  # Firewall configuration for web hosts.
  $firewall_rules = hiera_hash('site_profile::web::firewall_rules', {})
  create_resources(hiera('firewall_provider', 'firewall'), $firewall_rules)

  # Setup Apache base class, includes default vhost.
  class  { 'apache': }
  # Setup Vhosts.
  $vhosts = hiera_hash('site_profile::web::vhosts', {})
  create_resources('apache::vhost', $vhosts)

  # PHP
  # Setup php.ini.
  $php_ini = hiera_hash('site_profile::web::php_ini')
  create_resources('php::ini', hiera_hash('site_profile::web::php_ini', {}))

  class { 'php::cli': }
  class { 'php::mod_php5': }

  # Install PHP modules (extensions).
  $php_packages = hiera('site_profile::web::php_packages', [])
  $php_pear_packages = hiera('site_profile::web::php_pear_packages', [])
  if ($php_packages != []) {
    php::module { $php_packages: }
  }
  if ($php_pear_packages != []) {
    php::module { $php_pear_packages: }
  }

  # Install and configure PHP opcache (either APC or Zend Opcache).
  $opcache_pkg_name = hiera('site_profile::web::php_opcache_packagename', 'php-pecl-apc')
  php::module { $opcache_pkg_name: }
  case $opcache_pkg_name {
    /opcache/: {
      php::module::ini { 'opcache':
        pkgname  => $opcache_pkg_name,
        prefix   => hiera('site_profile::web::php_opcache_prefix', '10'),
        settings => hiera_hash('site_profile::web::php_opcache_ini', {}),
        zend     => true,
      }
    }
    default: {
      php::module::ini { 'apc':
        pkgname  => $opcache_pkg_name,
        settings => hiera_hash('site_profile::web::php_apc_ini', {}),
      }
    }
  }

  # Memcache module configuration.
  $enable_php_memcache = hiera('site_profile::web::enable_php_memcached', TRUE)
  if ($enable_php_memcache) {
    $php_memcache_packagename = hiera('site_profile::web::php_memcache_packagename', 'php-pecl-memcache')
    php::module { "$php_memcache_packagename": }
    php::module::ini { 'memcache':
      pkgname  => $php_memcache_packagename,
      prefix   => hiera('site_profile::web::php_memcache_prefix', '40'),
      settings => hiera_hash('site_profile::web::php_memcache_ini', {}),
    }
  }

  # Install Drush.
  class { 'yumrepos::drush8': }

  package { 'drush':
    ensure  => latest,
    require => Class['yumrepos::drush8'],
  }

  # Setup memcached.
  $enable_memcached = hiera('site_profile::web::enable_memcached', TRUE)
  if ($enable_memcached) {
    class {'memcached': }
  }

}
