#
# NodeJS and MPM install.
#
# Required Modules:
#   https://forge.puppet.com/stahnma/epel
#
class app_local::components::node {

  # https://nodejs.org
  package { 'nodejs':
    ensure  => 'installed',
    require => Class['epel'],
  }

  # https://www.npmjs.com
  package { 'npm':
    ensure  => 'installed',
    require => Package['nodejs'],
  }
}
