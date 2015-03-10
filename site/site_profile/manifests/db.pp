# Class site_profile::db
#
# Configuration for database servers.
#
class site_profile::db {

  # site_profile::dbclient class handles mysql->mysql55 client/libs packages,
  # Which is useful for getting newer mysql libs on EL6.
  require site_profile::dbclient

  class { 'mysql::server': }

  # Need to run the dbclient class first before installing the server
  # due to packaging conflicts between base mysql and IUS mysql.
  Class['site_profile::dbclient'] -> Class['mysql::server']

  # Install mysql related packages some of which come from Percona's repo.
  class { 'yumrepos::percona': }

  $mysql_additional_pkgs = hiera_array('site_profile::db::mysql_additional_pkgs', [])
  if ($mysql_additional_pkgs != []) {
    package { $mysql_additional_pkgs:
      ensure  => installed,
      require => Class['yumrepos::percona'],
    }
  }

}
