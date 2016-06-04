#
# Apache and PHP Configuration.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/apache
#
class app::components::apache {

  $doc_root = '/app/web'
  $doc_source = '/app/source'

  $projects = hiera('projects', [])

  # Create links to the public directories of each repository.
  $projects.each |$name, $mappings| {

      $from_dir = "${doc_source}/${name}"
      $to_dir = "${doc_root}/${mappings['public']}"

      file { $to_dir:
        ensure => 'link',
        target => $from_dir,
      }
    }

  class { 'apache':
    default_vhost => false,
    user          => 'vagrant',
    group         => 'vagrant'
  }

  file { $doc_root:
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'vagrant',
  }

  file { $doc_source:
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'vagrant',
  }

  php::ini { '/etc/php.ini':
    date_timezone => 'Australia/Brisbane',
    memory_limit  => '-1', # Set no memory limit.
  }

  apache::vhost { 'localhost':
    port        => '443',
    docroot     => $doc_root,
    ssl         => true,
    require     => [
      File[$doc_root],
      File['/etc/php.ini'],
    ],
    directories => [
      {
        path           => $doc_root,
        require        => 'all granted',
        options        => [
          'Indexes',
          'FollowSymLinks',
        ],
        allow_override => [
          'All'
        ],
      }
    ]
  }

  class { 'apache::mod::php': }

  file { "${doc_root}/about.php":
    ensure  => 'file',
    owner   => 'vagrant',
    group   => 'vagrant',
    content => '<?php phpinfo();',
    require => Class['apache::mod::php']
  }

  package { 'php-mysql':
    ensure  => 'installed',
    require => Class['apache::mod::php'],
  }

  package { 'php-pdo':
    ensure  => 'installed',
    require => Class['apache::mod::php'],
  }

  package { 'php-odbc':
    ensure  => 'installed',
    require => Class['apache::mod::php'],
  }

  package { 'php-pgsql':
    ensure  => 'installed',
    require => Class['apache::mod::php'],
  }
}
