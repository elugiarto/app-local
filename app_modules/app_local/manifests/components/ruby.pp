#
# Ruby Configuration and useful global packages.
#
class app_local::components::ruby {

  $packages = [
    'bundler', # http://bundler.io
    'sass', # http://sass-lang.com
    'rake', # https://github.com/ruby/rake
  ]

  package { 'ruby':
    ensure => 'installed',
  }

  $packages.each |$package| {
      exec { $package:
        command => "gem install ${package}",
        require => Package['ruby'],
        unless  => "gem list | grep -q ${package}",
      }
    }
}
