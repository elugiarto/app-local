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
    remove_default_accounts => false, # TODO: Switch back later.
  }

  class { 'mysql::client': }

  # Given we are running inside a vagrant VM, will this be a problem at all?
  mysql_grant { '*@*/*.*':
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => '*@*',
    require    => Class['mysql::server'],
  }
}
