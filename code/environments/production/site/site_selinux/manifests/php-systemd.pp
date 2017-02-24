# Class site_selinux::php-systemd
#
# Selinux contexts for web servers running php-fpm via systemd.
class site_selinux::php-systemd {

  # Custom php-systemd selinux module: allow php-systemd to do its socket magic.
  selinux::module { 'php-systemd':
    source => 'puppet:///modules/site_selinux/php-systemd/php-systemd.te',
  }

  # Use semanage to assign ports tcp/9000-9010 to php-fpm.
  exec { 'semanage-port-9000-9010':
    command => '/usr/sbin/semanage port -a -t php_port_t -p tcp 9000-9010',
    unless  => '/bin/grep php_port_t /etc/selinux/targeted/modules/active/ports.local | /bin/grep -q 9010',
    require => Selinux::Module['php-systemd'],
  }
}
