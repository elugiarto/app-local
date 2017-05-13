class app_local::components::oracle::xe_db (
  $enable_oracle_xe    = $::app_local::params::enable_oracle_xe,
  $xe_zip              = $::app_local::params::xe_zip,
  $xe_zip_path         = "/tmp/${xe_zip}",
  $xe_zip_extract_path = "/tmp/oracle-xe/",
  $xe_rpm_path         = "${xe_zip_extract_path}Disk1/${regsubst($xe_zip, '\.zip$', '')}",
  $xe_rsp              = "/tmp/oracle-xe.rsp",
  $xe_http_port        = 8080,
  $xe_listen_port      = 1521,
  $xe_env              = '/etc/profile.d/oracle-env.sh',
  $xe_password         = $::app_local::params::xe_root_password,
  $xe_command          = '/etc/init.d/oracle-xe',
  $xe_configured       = '/oracle-xe-configured',
  $sqlplus             = '/usr/lib/oracle/12.1/client64/bin/sqlplus',

) inherits app_local::params {

  if $enable_oracle_xe {

    package { ['glibc', 'binutils', 'gcc', 'libaio', 'bc', 'flex', 'unzip']:
      ensure => 'installed',
    }

    file { $xe_zip_path:
      ensure => 'file',
      source => "puppet:///modules/${module_name}/${xe_zip}",
    }

    file { $xe_rsp:
      ensure  => 'file',
      content => template("${module_name}/xe.rsp.erb"),
    }

    file { $xe_env:
      ensure  => 'file',
      content => template("${module_name}/oracle-env.sh.erb"),
    }

    exec { "unzip ${xe_zip_path}":
      command => "unzip ${xe_zip_path} -d ${xe_zip_extract_path}",
      unless  => "test -e ${xe_zip_extract_path}",
      require => File[$xe_zip_path],
    }

    # OracleXE DB requires larger than default swap size.
    swap_file::files { 'default':
      ensure       => present,
      swapfilesize => '2048MB'
    }

    exec { 'install oracle-xe':
      command => "/bin/rpm -i -ivh --nosignature ${xe_rpm_path}",
      creates => $xe_command,
      user    => 'root',
      group   => 'root',
      require => [
        Exec["unzip ${xe_zip_path}"],
        Package['glibc', 'make', 'binutils', 'gcc', 'libaio', 'bc', 'flex', 'unzip'],
        Swap_file::Files['default'],
      ]
    }

    exec { 'configure oracle-xe':
      command => "${xe_command} configure responseFile=${xe_rsp}",
      creates => $xe_configured,
      user    => 'root',
      group   => 'root',
      require => [
        File[$xe_rsp],
        File[$xe_env],
        Exec['install oracle-xe'],
        Firewall['100 allow oracle xe access'],
      ],
    }

    exec { 'create post setup file':
      command => "/bin/touch ${xe_configured}",
      creates => $xe_configured,
      user    => 'root',
      group   => 'root',
      require => Exec['configure oracle-xe'],
    }

    exec { 'enable remote access':
      command => "echo 'EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);' | ${sqlplus} system/${
        xe_password}",
      user    => 'root',
      group   => 'root',
      require => Exec['configure oracle-xe'],
    }

    # TODO: Create schemas now including initial temp data setup.

    # -- Setup DB if not already done.
    # CREATE TABLESPACE tbs_perm_01
    # DATAFILE 'tbs_perm_01.dbf'
    # SIZE 20M AUTOEXTEND ON;
    # CREATE TEMPORARY TABLESPACE tbs_temp_01
    # TEMPFILE 'tbs_temp_01.dbf'
    # SIZE 5M AUTOEXTEND ON;
    #
    # -- Create the "EXAMPLE" schema.
    # CREATE USER EXAMPLE
    # IDENTIFIED BY password
    # DEFAULT TABLESPACE tbs_perm_01
    # TEMPORARY TABLESPACE tbs_temp_01
    # QUOTA 100M on tbs_perm_01;
    #
    # -- Give all access to new schema.
    # GRANT ALL PRIVILEGES TO EXAMPLE;
  }
}
