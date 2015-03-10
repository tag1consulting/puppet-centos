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
  if (hiera('site_profile::dbclient::replace_mysql_with_mysql55', TRUE)) {
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

  $mysql_client_packages = hiera_array('site_profile::dbclient::mysql_client_packages')

  package { $mysql_client_packages:
    ensure  => installed,
    require => $mysql_client_require,
  }

}
