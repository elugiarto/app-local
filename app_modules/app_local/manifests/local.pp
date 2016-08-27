#
# Base Configuration.
#
node 'localhost' {

  # https://fedoraproject.org/wiki/EPEL
  class { 'epel': }

  # Set base configuration for exec.
  Exec {
    path     => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ],
    provider => 'shell',
  }

  class { 'app_local::components::firewall': }
  class { 'app_local::components::apache': }
  class { 'app_local::components::mysql': }
  class { 'app_local::components::node': }
  # class { 'app_local::components::ruby': }
  class { 'app_local::components::oracle::xe': }
}
