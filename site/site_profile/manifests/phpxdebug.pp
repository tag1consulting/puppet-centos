class site_profile::phpxdebug (
  $xdebug_package_name = 'php56u-pecl-xdebug',
  $xdebug_ini_prefix   = '15',
  $xdebug_settings     = { 'xdebug.remote_enable' => 1, 'xdebug.remote_connect_back' => 1, },
) {

  package { $xdebug_package_name:
    ensure => installed,
  }

  php::module::ini { 'xdebug':
    pkgname  => $xdebug_package_name,
    prefix   => $xdebug_ini_prefix,
    settings => $xdebug_settings,
    zend     => true,
  }

}
