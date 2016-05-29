#
# Apache Configuration.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/apache
#
class app::components::apache {

  $doc_root = '/app'

  class { 'apache':
    default_vhost => false,
    user          => 'vagrant',
    group         => 'vagrant'
  }

  file { $doc_root:
    ensure  => 'directory',
  }

  php::ini { '/etc/php.ini':
    date_timezone => 'Australia/Brisbane',
    memory_limit  => '-1', # Set no memory limit.
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
        allow_override => [
          'All'
        ],
      }
    ]
  }

  # PHP version management based on http://stackoverflow.com/questions/21502656/upgrading-php-on-centos-6-5-final

  exec { 'Webtatic Repository':
    command     => '/usr/bin/rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm',
    refreshonly => true,
  }

  exec { 'Remove PHP Common':
    command     => '/usr/bin/yum remove php-common',
    refreshonly => true,
    require     => Exec['Webtatic Repository'],
  }

  package { 'php56w':
    ensure  => 'installed',
    require => [
      Class['epel'],
      Exec['Remove PHP Common']
    ],
  }

  package { 'php56w-mysql':
    ensure  => 'installed',
    require => Package['php56w'],
  }

  package { 'php56w-common':
    ensure  => 'installed',
    require => Package['php56w'],
  }

  package { 'php56w-pdo':
    ensure  => 'installed',
    require => Package['php56w'],
  }

  package { 'php56w-opcache':
    ensure  => 'installed',
    require => Package['php56w'],
  }

  package { 'php56w-odbc':
    ensure  => 'installed',
    require => Package['php56w'],
  }

  package { 'php56w-pgsql':
    ensure  => 'installed',
    require => Package['php56w'],
  }

  class { 'apache::mod::php':
    require => [
      Package['php56w']
    ],
  }

  file { "${doc_root}/about.php":
    ensure  => 'file',
    owner   => 'vagrant',
    group   => 'vagrant',
    content => '<?php phpinfo();',
    require => Class['apache::mod::php']
  }
}
