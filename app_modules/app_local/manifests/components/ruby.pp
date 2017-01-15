#
# Ruby install and useful global packages.
#
# Required Modules:
#   https://forge.puppet.com/stahnma/epel
#
class app_local::components::ruby {

  $packages = [
    'bundler', # http://bundler.io
    'sass', # http://sass-lang.com
    'rake', # https://github.com/ruby/rake
  ]

  package { 'ruby':
    ensure  => 'installed',
    require => Class['epel'],
  }

  $packages.each |$package| {
    exec { $package:
      command => "gem install ${package}",
      require => Package['ruby'],
      unless  => "gem list | grep -q ${package}",
    }
  }
}
