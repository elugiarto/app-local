#
# NodeJS and MPM install.
#
# When running npm from within puppet you must manually source the .basrc file as it bootstraps the
# nvm library for loading the version of node it manages. This is not required when using npm from
# within the VM as this file is sourced by default when you ssh in.
#
# Required Modules:
#   https://forge.puppet.com/artberri/nvm
#
class app_local::components::node {

  $node_version = '7.4.0';
  $npm_cli = 'source /home/vagrant/.bashrc && npm';

  $packages = [
    'node-gyp',
  ]

  class { 'nvm':
    user         => 'vagrant',
    install_node => $node_version,
  }

  $packages.each |$package| {
    exec { $package:
      command => "${npm_cli} install -g ${package}",
      require => Class['nvm'],
      unless  => "${npm_cli} list -g --depth=0 | grep -q ${package}",
    }
  }
}
