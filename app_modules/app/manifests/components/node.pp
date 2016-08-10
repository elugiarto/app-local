#
# NodeJS Configuration.
#
# Required Modules:
#   https://forge.puppet.com/stahnma/epel
#
class app::components::node {

  # https://nodejs.org
  package { 'nodejs':
    ensure  => 'installed',
    require => Class['epel'],
  }

  # https://www.npmjs.com
  package { 'npm':
    ensure  => 'installed',
    require => Package['nodejs'],
  }

  $packages = [
    'grunt-cli', # http://gruntjs.com
    'gulp-cli', # http://gulpjs.com
    'webpack', # http://webpack.github.io
    'bower', # https://bower.io
    'eslint', # http://eslint.org
    'jspm', # http://jspm.io
    'typescript', # https://www.typescriptlang.org
    'babel-cli', # https://babeljs.io
  ]

  $packages.each |$package| {
      exec { $package:
        command => "npm install -g ${package}",
        require => Package['npm'],
        unless  => "npm -g list --depth=0 | grep -q ${package}",
      }
    }
}
