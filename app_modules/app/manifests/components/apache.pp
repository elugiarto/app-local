#
# Apache and PHP Configuration.
# PHP configuration is based on https://webtatic.com/packages/php55/, to enable version 5.5 support.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/apache
#
class app::components::apache {

  $app_root = '/app'
  $doc_root = '/app/web'
  $doc_source = '/app/source'
  $security_key = '/app/security key'

  $projects = hiera('projects', [])

  # Create links to the public directories of each repository.
  $projects.each |$name, $mappings| {
      file { "${doc_root}/${name}":
        ensure => 'link',
        target => "${doc_source}/${name}${mappings['public']}",
      }
    }

  class { 'apache':
    default_vhost => false,
    user          => 'vagrant',
    group         => 'vagrant'
  }

  file { $app_root:
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'vagrant',
  }

  file { $doc_root:
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'vagrant',
    require => File[$app_root],
  }

  file { $doc_source:
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'vagrant',
    require => File[$app_root],
  }

  file { $security_key:
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'vagrant',
    require => File[$app_root],
  }

  file { "${security_key}/.pingsinglesignon.php":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/pingsinglesignon.php.erb"),
    require => File[$security_key],
  }

  file { "${doc_root}/logout.php":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/logout.php.erb"),
    require => File[$doc_root],
  }

  file { "${doc_root}/login.php":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/login.php.erb"),
    require => File[$doc_root],
  }

  file { '/etc/php.ini':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/php.ini.erb"),
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

  $install_options = [
    '-Uvh',
    '--nosignature'
  ]

  package { 'epel-release-7-7.noarch':
    ensure          => 'installed',
    provider        => 'rpm',
    source          => 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm',
    install_options => $install_options,
  }

  package { 'webtatic-release-7-3.noarch':
    ensure          => 'installed',
    provider        => 'rpm',
    source          => 'https://mirror.webtatic.com/yum/el7/webtatic-release.rpm',
    install_options => $install_options,
  }

  class { 'apache::mod::php':
    package_name   => 'php55w', # Ensure we install php 5.5 package.
    package_ensure => 'installed',
    require        => [
      Package['epel-release-7-7.noarch'],
      Package['webtatic-release-7-3.noarch']
    ],
  }

  file { "${doc_root}/about.php":
    ensure  => 'file',
    owner   => 'vagrant',
    group   => 'vagrant',
    content => '<?php phpinfo();',
    require => Class['apache::mod::php']
  }

  package { 'php55w-opcache':
    ensure  => 'installed',
    require => [
      Package['php55w'],
    ],
  }

  package { 'php55w-mysql':
    ensure  => 'installed',
    require => [
      Package['php55w'],
    ],
  }

  package { 'php55w-pdo':
    ensure  => 'installed',
    require => [
      Package['php55w'],
    ],
  }

  package { 'php55w-odbc':
    ensure  => 'installed',
    require => [
      Package['php55w'],
    ],
  }

  package { 'php55w-pgsql':
    ensure  => 'installed',
    require => [
      Package['php55w'],
    ],
  }
}
