# Class site_profile::base
# 
# Default class, should be pulled in for every node.
#
class site_profile::base {
  # Firewall configuration is optional, but defaults to TRUE.
  $enable_firewall = hiera('enable_firewall', TRUE)
  if ($enable_firewall) {
    # Firewall configuration common for all hosts.
    $firewall_rules = hiera_hash('site_profile::base::firewall_rules', {})
    create_resources('firewall', $firewall_rules)
  }

  # Packages to be added to all machines for convenience or necessity.
  $base_packages = hiera_array('site_profile::base::base_packages', [])
  if ($base_packages != []) {
    package { $base_packages:
      ensure => installed,
    }
  }

  # System groups.
  $system_groups = hiera_hash('system_groups', {} )
  create_resources('group', $system_groups)

  # User Accounts. Passwords should be stored in private hiera repo.
  $user_accounts = hiera_hash('user_accounts', {} )
  create_resources('account', $user_accounts)

  # Base Sudo setup.
  class { 'sudo': }

  # Include base sudo configuration from hiera.
  $sudo_conf = hiera_hash('site_profile::base::sudo_conf', {})
  create_resources('sudo::conf', $sudo_conf)

  # sshd configuration.
  class { 'ssh::server': }

  # Denyhosts.
  if (hiera('enable_denyhosts', FALSE)) {
    class { 'denyhosts': }
  }

  # Enable yum cron.
  # If enabled, defaults to only check for updates, not update automatically.
  if (hiera('enable_yum_cron', FALSE)) {
    class { 'yum_cron': }
  }
  else {
    package { 'yum-cron':
      ensure => 'absent',
    }
  }

}
