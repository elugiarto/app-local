#
# Firewall Configuration.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/firewall
#
class app::components::firewall {

  class { 'firewall': }

  # HTTPS access to apache httpd.
  firewall { '100 allow https access':
    dport  => [443],
    proto  => tcp,
    action => accept,
  }

  # MySQL database access.
  firewall { '400 Accept incoming port MYSQL':
    chain  => 'INPUT',
    action => 'accept',
    state  => 'NEW',
    proto  => 'tcp',
    dport  => ['3306'],
  }
}
