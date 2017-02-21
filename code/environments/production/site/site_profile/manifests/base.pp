# Class site_profile::base
# 
# Default class, should be pulled in for every node.
#
class site_profile::base {
  # Firewall configuration is optional, but defaults to TRUE.
  $enable_firewall = lookup('enable_firewall', { 'value_type' => Boolean, 'default_value' => true, })
  if ($enable_firewall) {
    $firewall_rules = lookup('site_profile::base::firewall_rules',
                             { 'value_type'    => Hash,
                               'merge'         => 'deep',
                               'default_value' => {},
                             })
    $firewall_provider = lookup('firewall_provider', { 'value_type' => String, 'default_value' => 'firewall', })
    create_resources($firewall_provider, $firewall_rules)
  }

  # Packages to be added to all machines for convenience or necessity.
  $base_packages = lookup('site_profile::base::base_packages',
                          { 'value_type'    => Array,
                            'merge'         => 'unique',
                            'default_value' => [],
                          })
  if ($base_packages != []) {
    package { $base_packages:
      ensure => installed,
    }
  }

  # System groups.
  $system_groups = lookup('system_groups', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => {}, })
  create_resources('group', $system_groups)

  # User Accounts. Passwords should be stored in private hiera repo.
  $user_accounts = lookup('user_accounts', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => {}, })
  create_resources('account', $user_accounts)

  # SELinux configuration for all hosts.
  class { 'site_selinux': }

  # Base Sudo setup.
  class { 'sudo': }

  # Include base sudo configuration from hiera.
  $sudo_conf = lookup('site_profile::base::sudo_conf', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => {}, })
  create_resources('sudo::conf', $sudo_conf)

  # sshd configuration.
  class { 'ssh::server': }

}
