# site.pp

# Pull "hostenv" (a.k.a environment) and "type" out of fqdn
# to be used by Hiera. See README.md for more information on hiera grouping.
# Hostname examples:
# prod-web1.example.com => hostenv: prod; hosttype: web
# stage-db1.example.com => hostenv: stage; hosttype: db
# dev-multi1.example.com => hostenv: stage; hosttype: multi
# vagrant-multi1.dev => hostenv: vagrant; hosttype: multi
$hostenv = regsubst($fqdn, '^([a-z]+)-([a-z]+)(\d)\.(.*)$', '\1')
$hosttype = regsubst($fqdn, '^([a-z]+)-([a-z]+)(\d)\.(.*)$', '\2')

# Classes are included via Hiera by looking at the 'classes' array.
hiera_include('classes')

filebucket { 'main': server => puppet }

# Global defaults.
File {
  owner  => 'root',
  group  => 'root',
  mode   => 0644,
  backup => main
}

Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

# Set allow_virtual for newer Puppet versions.
if (versioncmp($::puppetversion, '3.6.1') >= 0) {
  $allow_virtual= hiera('allow_virtual_packages', TRUE)
  Package {
    allow_virtual => $allow_virtual,
  }
}

node default {
  stage { 'pre': before => Stage['main'] }

  # The profile classes depend on EPEL and IUS being in place,
  # so the repos are included in the "pre" stage.
  class { 'yumrepos::epel': stage => 'pre' }
  class { 'yumrepos::ius': stage => 'pre' }

  # EL6 firewall config needs some extra pre/post logic.
  $enable_firewall = hiera('enable_firewall', TRUE)
  if($enable_firewall and $operatingsystemmajrelease == 6) {
    resources { 'firewall':
      purge => true
    }
    class { 'firewall': stage => 'pre' }
    Firewall {
      before  => Class['site_iptables::post'],
      require => Class['site_iptables::pre'],
    }
    class { 'site_iptables::pre': stage => 'pre' }
    class { 'site_iptables::post': }
  }

}
