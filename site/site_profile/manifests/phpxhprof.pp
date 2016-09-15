class site_profile::phpxhprof (
  $php_package_name    = 'php56u-pecl-xhprof',
  $xhprof_package_name = 'xhprof',
  $ini_prefix          = '40',
  $ini_settings        = { 'xhprof.output_dir' => '/tmp', },
  $xhprof_crons        = {},
) {

  class { 'yumrepos::php56xhprof': }

  package { $php_package_name:
    ensure  => installed,
    require => Class['yumrepos::php56xhprof'],
  }

  package { $xhprof_package_name:
    ensure  => installed,
    require => Class['yumrepos::php56xhprof'],
  }

  php::module::ini { 'xhprof':
    pkgname  => $php_package_name,
    prefix   => $ini_prefix,
    settings => $ini_settings,
  }

  # Create cron jobs if any are specified. To e.g. clean up temp xhprof files.
  create_resources('cron', $xhprof_crons)

  # XHGui needs MongoDB
  class { '::mongodb::server': }
  class { '::mongodb::client': }

  # Add XHGui
  #include composer
  class { 'xhgui':
    vhost_name        => 'vagrant-xhgui.tag1consulting.com',
    sample_size       => '1',
    php_mongo_package => 'php56u-pecl-mongo',
    xhprof_package    => $xhprof_package_name,
  }

}
