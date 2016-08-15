#
# Base Configuration.
#
node 'localhost' {

  # https://fedoraproject.org/wiki/EPEL
  class { 'epel': }

  # Set path for exec once.
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ] }

  class { 'app_local::components::firewall': }
  class { 'app_local::components::apache': }
  class { 'app_local::components::mysql': }
  class { 'app_local::components::node': }
}
