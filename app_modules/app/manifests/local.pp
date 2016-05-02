#
# Base Configuration.
#
node 'localhost' {
  class { 'app::components::firewall': }
  class { 'app::components::apache': }
  class { 'app::components::mysql': }
}
