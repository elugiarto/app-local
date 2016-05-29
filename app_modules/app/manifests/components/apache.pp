#
# Apache Configuration.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/apache
#
# TODO: Manage php version, see http://php.net/manual/en/install.unix.apache2.php.
# TODO: Revisit use of vagrant:vagrant for apache.
#
class app::components::apache {

  $doc_root = '/app'

  class { 'apache':
    default_vhost => false,
    user          => 'vagrant', # For simplicity, run with vagrant here.
    group         => 'vagrant'
  }

  file { $doc_root:
    ensure  => 'directory',
  }

  file { '/etc/php.ini':
    source => "puppet:///modules/${module_name}/php.ini"
  }

  apache::vhost { 'app.local':
    port        => '443',
    docroot     => $doc_root,
    ssl         => true,
    options     => [
      'Indexes',
    ],
    require     => [
      File[$doc_root],
      File['/etc/php.ini'],
    ],
    directories => [
      {
        path           => $doc_root,
        require        => 'all granted',
        options        => [],
        allow_override => [
          'All'
        ],
      }
    ]
  }

  class { 'apache::mod::php':
    require => [
      Package['php-xml'],
      Package['php-pdo'],
    ],
  }

  package { 'php-xml':
    ensure => 'installed',
  }

  package { 'php-pdo':
    ensure => 'installed',
  }

  file { "${doc_root}/about.php":
    ensure  => 'file',
    owner   => 'vagrant',
    group   => 'vagrant',
    content => '<?php phpinfo();',
    require => Class['apache::mod::php']
  }
}
