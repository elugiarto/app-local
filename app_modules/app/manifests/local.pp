#
# Base Configuration.
#
node 'localhost' {

  # https://fedoraproject.org/wiki/EPEL
  class { 'epel': }

  # Set path for exec once.
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ] }

  class { 'app::components::firewall': }
  class { 'app::components::apache': }
  class { 'app::components::mysql': }
  class { 'app::components::node': }
}
