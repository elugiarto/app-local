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
    override_options        => {
      'mysqld' => {
        'bind-address' => '0.0.0.0', # User firewall to manage access ips instead.
      }
    }
  }

  class { 'mysql::client': }

  if $mysql.has_key('databases') {
    $mysql['databases'].each |$name, $db_config| {
        mysql_database { $name:
          ensure  => 'present',
          charset => 'utf8',
          collate => 'utf8_general_ci',
        }

        if $db_config.has_key('users') {
          $db_config['users'].each |$username, $user_config| {
              mysql_user { "$username@%":
                ensure        => 'present',
                password_hash => mysql_password($user_config['password']),
              }

              mysql_grant { "$username@%/$name.*":
                ensure     => 'present',
                privileges => $user_config['grants'],
                user       => "$username@%",
                table      => "$name.*",
              }
            }
        }
      }
  }
}
