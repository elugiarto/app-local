#
# Base Configuration.
#
node 'localhost' {

  # https://fedoraproject.org/wiki/EPEL
  class { 'epel': }

  class { 'app::components::firewall': }
  class { 'app::components::apache': }
  class { 'app::components::mysql': }
}
