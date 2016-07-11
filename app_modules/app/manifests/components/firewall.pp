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
  firewall { '100 allow mysql access':
    dport  => [3306],
    proto  => tcp,
    action => accept,
  }
}
