#
# MySQL Configuration.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/mysql
#
class app::components::mysql {

  $mysql = hiera('mysql')
  $root_password = $mysql['root_password']

  class { 'mysql::server':
    root_password           => $root_password,
    remove_default_accounts => true,
  }

  class { 'mysql::client': }
}
