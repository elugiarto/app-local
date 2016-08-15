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
  $answer_pecl_oci8 = 'answer-pecl-oci8.txt'
  $java_version = '1.8.0'
  $instant_client_version = '12.1' # TODO: Determine dynamically from above rpms.

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
      content => template("${module_name}/oracle.sh.erb"),
      require => [
        Package["java-${java_version}-openjdk-devel"],
        Package['oracle-instantclient-basic'],
        Package['oracle-instantclient-devel'],
        Package['oracle-instantclient-sqlplus'],
      ];
  }

  package {
    "java-${java_version}-openjdk-devel":
      ensure  => 'installed';

    'oracle-instantclient-basic':
      provider        => 'rpm',
      name            => $instant_client_basic,
      source          => "/tmp/${instant_client_basic}",
      ensure          => 'installed',
      install_options => '--force',
      require         => File["/tmp/${instant_client_basic}"];

    'oracle-instantclient-devel':
      provider        => 'rpm',
      name            => $instant_client_development,
      source          => "/tmp/${instant_client_development}",
      ensure          => 'installed',
      install_options => '--force',
      require         => [
        File["/tmp/${instant_client_development}"],
        Package['oracle-instantclient-basic'],
      ];

    'oracle-instantclient-sqlplus':
      provider        => 'rpm',
      name            => $instant_client_sqlplus,
      source          => "/tmp/${instant_client_sqlplus}",
      ensure          => 'installed',
      install_options => '--force',
      require         => [
        File["/tmp/${instant_client_sqlplus}"],
        Package['oracle-instantclient-devel'],
      ];
  }
}
