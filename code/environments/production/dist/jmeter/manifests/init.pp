# Class: jmeter
#
# Installs Apache JMeter to /usr/local/jmeter and
# creates a symlink to the 'jmeter' script in /usr/local/bin.
#
class jmeter (
  $install_path = '/usr/local/jmeter',
  $jmeter_tar   = 'apache-jmeter-2.11.tgz',
) {

  file { $install_path:
    ensure => directory,
  }

  file { "${install_path}/${jmeter_tar}":
    ensure  => present,
    source  => "puppet:///modules/jmeter/${jmeter_tar}",
    require => File[$install_path],
  }

  exec { 'untar-jmeter':
    creates => "${install_path}/bin/jmeter",
    cwd     => $install_path,
    command => "/bin/tar zxf ${jmeter_tar} --strip-components=1",
    umask   => 0022,
    require => File["${install_path}/${jmeter_tar}"],
  }
}
