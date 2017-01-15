#
# Install and configure, Oracle Instant Client.
#
# Test sqlplus with:
#    sqlplus "user/pass@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=hostname.network)(Port=1521))(CONNECT_DATA=(SID=remote_SID)))"
#
class app_local::components::oracle::instant_client {

  $instant_client_basic = hiera('oracle_instantclient_basic', '')
  $instant_client_development = hiera('oracle_instantclient_development', '')
  $instant_client_sqlplus = hiera('oracle_instantclient_sqlplus', '')

  $java_version = '1.8.0'

  if ($instant_client_basic != '') {

    # This is required for /etc/profile.d/oracle.sh
    $instant_client_version = $instant_client_basic.match(/[a-z\-]+([0-9\.]+).+/)[1]

    file {
      "/tmp/${instant_client_basic}":
        source => "puppet:///modules/${module_name}/${instant_client_basic}";

      "/tmp/${instant_client_development}":
        source => "puppet:///modules/${module_name}/${instant_client_development}";

      "/tmp/${instant_client_sqlplus}":
        source => "puppet:///modules/${module_name}/${instant_client_sqlplus}";

      '/etc/profile.d/oracle.sh':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0655',
        content => dos2unix(template("${module_name}/oracle.sh.erb")),
        require => [
          Package["java-${java_version}-openjdk-devel.x86_64"],
          Package['oracle-instantclient-basic'],
          Package['oracle-instantclient-devel'],
          Package['oracle-instantclient-sqlplus'],
        ];
    }

    package {
      "java-${java_version}-openjdk-devel.x86_64":
        ensure  => 'installed',
        require => Class["epel"];

      'oracle-instantclient-basic':
        ensure          => 'installed',
        provider        => 'rpm',
        name            => $instant_client_basic,
        source          => "/tmp/${instant_client_basic}",
        install_options => '--force',
        require         => File["/tmp/${instant_client_basic}"];

      'oracle-instantclient-devel':
        ensure          => 'installed',
        provider        => 'rpm',
        name            => $instant_client_development,
        source          => "/tmp/${instant_client_development}",
        install_options => '--force',
        require         => [
          File["/tmp/${instant_client_development}"],
          Package['oracle-instantclient-basic'],
        ];

      'oracle-instantclient-sqlplus':
        ensure          => 'installed',
        provider        => 'rpm',
        name            => $instant_client_sqlplus,
        source          => "/tmp/${instant_client_sqlplus}",
        install_options => '--force',
        require         => [
          File["/tmp/${instant_client_sqlplus}"],
          Package['oracle-instantclient-devel'],
        ];
    }

  } else {
    err('oracle_instantclient_basic must be defined and populated.')
  }
}
