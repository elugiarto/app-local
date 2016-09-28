#
# Firewall Configuration.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/firewall
#
class app_local::components::firewall {

  class { 'firewall': }

  firewall { '100 allow https access':
    dport  => [443],
    proto  => tcp,
    action => accept,
  }

  firewall { '100 allow mysql access':
    dport  => [3306],
    proto  => tcp,
    action => accept,
  }
}
