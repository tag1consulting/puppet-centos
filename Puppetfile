# This is currently a noop but will be supported in the future.
forge 'forge.puppetlabs.com'

# Install modules from the Forge
mod 'arioch/redis', '1.2.1'
mod 'crayfishx/firewalld', '1.0.0'
mod 'jfryman/selinux', '0.2.5'
mod 'puppetlabs/apache', '1.5.0'
mod 'puppetlabs/concat', '1.2.3'
mod 'puppetlabs/denyhosts', '0.1.0'
mod 'puppetlabs/firewall', '1.5.0'
mod 'puppetlabs/inifile', '1.3.0'
mod 'puppetlabs/java', '1.3.0'
mod 'puppetlabs/mysql', '3.4.0'
mod 'puppetlabs/stdlib', '4.6.0'
mod 'puppetlabs/vcsrepo', '1.3.0'
mod 'saz/sudo', '3.1.0'
mod 'saz/ssh', '2.8.1'
mod 'tag1/yumrepos', '0.9.0'
mod 'thias/php', '1.1.1'
mod 'treydock/yum_cron', '1.2.0'
mod 'torrancew/account', '0.0.5'

# This module installs policycoreutils-python which conflicts with the selinux module.
# Temporarily using a fork until https://github.com/RPDiep/puppet-memcached/issues/7 is sorted.
mod 'memcached',
  :git => 'git://github.com/jeffsheltren/puppet-memcached.git',
  :ref => 'no-policycoreutils'
