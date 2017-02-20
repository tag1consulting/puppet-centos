# Class site_profile::dbclient
#
# This class handles some mysql client package switching
# to allow us to install mysql55 from IUS.
#
# This is required because on CentOS 6 we use mysql55 from IUS,
# but older mysql-libs is installed by default, so we need to do
# some trickery to replace that package.
#
# To opt-opt of running this (e.g. it isn't necessary on EL7),
# set 'site_profile::dbclient::replace_mysql_with_mysql55' to FALSE in Hiera.
class site_profile::dbclient {
  $replace_mysql_with_mysql55 = lookup('site_profile::dbclient::replace_mysql_with_mysql55',
                                       { 'value_type' => 'Boolean',
                                         'default_value' => true,
                                       })
  if ($replace_mysql_with_mysql55) {
    exec { 'mysqlinstall':
      command => '/usr/bin/yum -y install mysql',
      unless  => '/bin/rpm -q --quiet mysql55',
    }

    exec { 'mysql55replace':
      command     => '/usr/bin/yum -y replace mysql --replace-with mysql55',
      refreshonly => true,
      subscribe   => Exec['mysqlinstall'],
      require     => Class['site_profile::base'],
    }
    $mysql_client_require = [ Exec['mysqlinstall'], Exec['mysql55replace'] ]
  }
  else {
    $mysql_client_require = [ ]
  }

  $mysql_client_packages = lookup('site_profile::dbclient::mysql_client_packages',
                                  { 'value_type'    => 'Array',
                                    'merge'         => 'unique',
                                    'default_value' => [],
                                  })

  package { $mysql_client_packages:
    ensure  => installed,
    require => $mysql_client_require,
  }

}
