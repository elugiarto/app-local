#
# Apache Configuration.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/apache
#
class app::components::apache {

  $doc_root = '/app'

  class { 'apache':
    default_vhost => false
  }

  file { $doc_root:
    ensure => 'directory'
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
    ],
    directories => [
      {
        path    => $doc_root,
        require => 'all granted',
        options => [
          'Indexes',
        ]
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
}
