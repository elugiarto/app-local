#
# Ruby Configuration.
#
# Required Modules:
#   https://forge.puppet.com/stahnma/epel
#
class app_local::components::ruby {

  $rbenv = '/usr/local/.rbenv'
  $ruby_version = '2.3.1'

  # Ruby related commands that are prefixed with profile loading. (Happens by default when ssh)
  $rbenv_cli = '. /etc/profile && rbenv'
  $ruby_cli = '. /etc/profile && ruby'
  $gem_cli = '. /etc/profile && gem'

  $packages = [
    'bundler', # http://bundler.io
    'sass', # http://sass-lang.com
    'rake', # https://github.com/ruby/rake
  ]

  package { ['git', 'readline-devel', 'openssl-devel', 'zlib-devel']:
    ensure  => 'installed',
  }

  exec { 'clone rbenv':
    command => "git clone https://github.com/rbenv/rbenv.git ${rbenv}",
    require => Package['git'],
    unless  => "test -d ${rbenv}",
  }

  file_line { 'rbenv path':
    path    => '/etc/profile',
    line    => "export PATH=\"${rbenv}/bin:\$PATH\"",
    require => Exec['clone rbenv'],
  }

  file_line { 'rbenv init path':
    path    => '/etc/profile',
    line    => "eval \"$(rbenv init -)\"",
    require => File_line['rbenv path'],
  }

  exec { 'clone ruby-build':
    command => "git clone https://github.com/rbenv/ruby-build.git ${rbenv}/plugins/ruby-build",
    require => File_line['rbenv init path'],
    unless  => "test -d ${rbenv}/plugins/ruby-build",
  }

  exec { 'install ruby-build':
    command => "${rbenv}/plugins/ruby-build/install.sh",
    require => Exec['clone ruby-build'],
    cwd     => "${rbenv}/plugins/ruby-build",
  }

  exec { "install ruby ${ruby_version}":
    command => "${rbenv_cli} install ${ruby_version}",
    unless  => "test -d /home/vagrant/.rbenv/versions/${ruby_version}",
    require => [
      Package['readline-devel', 'openssl-devel', 'zlib-devel'],
      Exec['install ruby-build'],
    ],
    timeout => 0, # Takes a long time to install so lets just wait.
  }

  exec { "global ruby ${ruby_version}":
    command => "${rbenv_cli} rehash && ${rbenv_cli} global ${ruby_version}",
    require => Exec["install ruby ${ruby_version}"],
    unless  => "${ruby_cli} --version | grep -q ${ruby_version}"
  }

  $packages.each |$package| {
      exec { $package:
        command => "${gem_cli} install ${package}",
        require => Exec["global ruby ${ruby_version}"],
        unless  => "${gem_cli} list | grep -q ${package}",
      }
    }
}
