# This is currently a noop but will be supported in the future.
forge 'forge.puppetlabs.com'

# Install modules from the Forge
mod 'arioch/redis', '1.2.2'
mod 'crayfishx/firewalld', '2.2.0'
mod 'jfryman/selinux', '0.4.0'
mod 'puppetlabs/apache', '1.8.1'
mod 'puppetlabs/concat', '2.2.0'
mod 'puppetlabs/denyhosts', '0.1.0'
mod 'puppetlabs/firewall', '1.8.1'
mod 'puppetlabs/git', '0.5.0'
mod 'puppetlabs/inifile', '1.5.0'
mod 'puppetlabs/java', '1.6.0'
mod 'puppetlabs/mysql', '3.8.0'
mod 'puppetlabs/mongodb', '0.14.0'
mod 'puppetlabs/stdlib', '4.12.0'
mod 'puppetlabs/vcsrepo', '1.3.2'
mod 'saz/sudo', '3.1.0'
mod 'saz/ssh', '2.8.1'
mod 'tag1/yumrepos', '0.9.1'
mod 'thias/php', '1.2.0'
mod 'treydock/yum_cron', '2.0.0'
mod 'torrancew/account', '0.1.0'
mod 'tPl0ch/composer', '1.3.7'

# This module installs policycoreutils-python which conflicts with the selinux module.
# Temporarily using a fork until https://github.com/RPDiep/puppet-memcached/issues/7 is sorted.
mod 'memcached',
  :git => 'git://github.com/jeffsheltren/puppet-memcached.git',
  :ref => 'no-policycoreutils'

# Not on the forge yet
mod 'xhgui',
  :git    => 'https://github.com/gchaix/puppet-xhgui.git',
  :branch => 'master'
