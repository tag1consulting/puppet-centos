# This is currently a noop but will be supported in the future.
forge 'forge.puppetlabs.com'

# Install modules from the Forge
mod 'jeffsheltren/yumrepos', '0.5.0'
mod 'puppetlabs/apache', '1.2.0'
mod 'puppetlabs/concat', '1.1.2'
mod 'puppetlabs/denyhosts', '0.1.0'
mod 'puppetlabs/firewall', '1.3.0'
mod 'puppetlabs/inifile', '1.2.0'
mod 'puppetlabs/java', '1.2.0'
mod 'puppetlabs/mysql', '3.1.0'
mod 'puppetlabs/stdlib', '4.5.0'
mod 'puppetlabs/vcsrepo', '1.2.0'
mod 'saz/sudo', '3.0.6'
mod 'saz/ssh', '2.3.6'
mod 'treydock/yum_cron', '1.0.0'
mod 'torrancew/account', '0.0.5'

# Using a direct git reference instead of a module install
# until these latest commits are rolled into a release.
# https://github.com/thias/puppet-php/pull/35
mod 'php',
  :git => 'git://github.com/jeffsheltren/puppet-php.git',
  :ref => '97fdea1775b0dbc45e341b9d2fe0d843f72a5818'

# Memcached fork should be OK after 2 PRs get in.
# https://github.com/RPDiep/puppet-memcached/pull/1
# https://github.com/RPDiep/puppet-memcached/pull/2
mod 'memcached',
  :git => 'git://github.com/rfay/puppet-memcached.git',
  :ref => 'master'
