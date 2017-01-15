#
# Apache and PHP Configuration.
# PHP configuration is based on https://webtatic.com/packages/php55/, to enable version 5.5 support.
#
# Required Modules:
#   https://forge.puppet.com/puppetlabs/apache
#
class app_local::components::apache_php {

  $app_root = '/app'
  $doc_root = '/app/web'
  $doc_source = '/app/source'
  $security_key = '/app/security key'

  $listen_ports = hiera('listen_ports')

  if ($listen_ports) {
    $base_url = "https://localhost:${listen_ports['https']}"

  } else {
    $base_url = 'https://localhost:8443' # Default configuration.
  }

  $sso_dummy_staff_number = hiera('sso_dummy_staff_number', 's123456')
  $sso_dummy_given_name = hiera('sso_dummy_given_name', 'Jane')
  $sso_dummy_family_name = hiera('sso_dummy_family_name', 'Doe')
  $sso_dummy_email = hiera('sso_dummy_email', 'jane.doe@example.com')
  $sso_dummy_group_memberships = hiera('sso_dummy_group_memberships', [
    'cn=General Staff (All),ou=Groups,o=Griffith University',
    'cn=Staff (NA),ou=Groups,o=Griffith University'
  ])
  $sso_dummy_affiliations = hiera('sso_dummy_affiliations', [
    'EMPLOYEE',
    'GENERAL'
  ])

  $path = '/usr/local/bin:/usr/bin:/bin'

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
    ensure  => 'directory',
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File[$app_root],
  }

  file { $doc_source:
    ensure  => 'directory',
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File[$app_root],
  }

  file { $security_key:
    ensure  => 'directory',
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File[$app_root],
  }

  file { "${security_key}/.pingsinglesignon.php":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => dos2unix(template("${module_name}/pingsinglesignon.erb")),
    require => File[$security_key],
  }

  file { '/etc/php.ini':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => dos2unix(template("${module_name}/php.ini.erb")),
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

  # See http://www.rpm.org/max-rpm/s1-rpm-install-additional-options.html
  $install_options = [
    '-Uvh',
    '--nosignature',
    '--replacepkgs' # Avoid getting an "Already Exists" warning by always replacing.
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

  package { ['php55w-common', 'php55w-opcache', 'php55w-mysql', 'php55w-pdo', 'php55w-odbc',
    'php55w-pgsql', 'php55w-devel', 'php55w-cli', 'php55w-pear', 'composer', 'php55w-zlib']:
    ensure  => 'installed',
    require => [
      Package['php55w'],
    ],
  }

  file { "${doc_root}/about.php":
    ensure  => 'file',
    owner   => 'vagrant',
    group   => 'vagrant',
    content => '<?php phpinfo();',
    require => [
      File[$doc_root],
      Class['apache::mod::php'],
    ],
  }

  # SSO emulated logout page.
  file { "${doc_root}/logout.php":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => dos2unix(template("${module_name}/logout.php.erb")),
    require => [
      File[$doc_root],
      Class['apache::mod::php'],
    ],
  }

  # SSO emulated login page.
  file { "${doc_root}/login.php":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => dos2unix(template("${module_name}/login.php.erb")),
    require => [
      File[$doc_root],
      Class['apache::mod::php'],
    ],
  }

  class { 'app_local::components::oracle::instant_client': }

  # Install oci8 https://pecl.php.net/package/oci8 for latest PHP 5.5 supported version.
  exec { 'install oci8':
    command => 'pecl install oci8-1.4.10',
    user    => 'root',
    group   => 'root',
    unless  => 'test -f /usr/lib64/php/modules/oci8.so',
    require => [
      Package['php55w-pear'],
      Class['app_local::components::oracle::instant_client']
    ],
  }

  exec { 'restart apache':
    command     => 'service httpd restart',
    refreshonly => true,
    subscribe   => [
      Exec['install oci8']
    ]
  }
}
