#
# Install Oracle XE Database.
#
class app_local::components::oracle::xe {

  $enable_xe = hiera('enable_oracle_xe', false)
  $xe_zip = hiera('oracle_xe')
  $xe = regsubst($xe_zip, '\.zip$', '')
  $xe_rpm = "/tmp/Disk1/${xe}"
  $xe_password = hiera('oracle_xe_root_password')

  if $enable_xe {
    package { ['unzip', 'glibc', 'make', 'binutils', 'gcc', 'libaio', 'bc', 'flex']:
      ensure  => 'installed',
    }

    swap_file::files { 'default':
      ensure       => present,
      swapfilesize => '2048MB'
    }

    file { "/tmp/${xe_zip}":
      source => "puppet:///modules/${module_name}/${xe_zip}"
    }

    exec { 'unzip xe':
      command => "unzip /tmp/${xe_zip}",
      cwd     => '/tmp',
      unless  => "test -e ${xe_rpm}",
      user    => 'vagrant',
      group   => 'vagrant',
      require => [
        File["/tmp/${xe_zip}"],
        Package['unzip'],
      ]
    }

    package { 'oracle-xe':
      ensure          => 'installed',
      provider        => 'rpm',
      install_options => [
        '-ivh',
        '--nosignature',
      ],
      source          => $xe_rpm,
      require         => [
        Class['app_local::components::oracle::instant_client'],
        Exec['unzip xe'],
        Package['glibc', 'make', 'binutils', 'gcc', 'libaio', 'bc', 'flex'],
        Swap_file::Files['default'],
      ]
    }

    file { '/tmp/xe.rsp':
      ensure  => 'file',
      owner   => 'vagrant',
      group   => 'vagrant',
      content => template("${module_name}/xe.rsp.erb"),
      require => Package['oracle-xe'],
    }

    exec { 'configure oracle-xe':
      command => '/etc/init.d/oracle-xe configure responseFile=/tmp/xe.rsp',
      cwd     => '/tmp',
      user    => 'root',
      group   => 'root',
      require => File['/tmp/xe.rsp'],
    }
  }
}
