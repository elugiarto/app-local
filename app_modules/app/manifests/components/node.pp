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

  #
  # Install a range of Node CLI tools.
  #

  # http://gruntjs.com
  exec { 'grunt-cli':
    command => 'npm install -g grunt-cli',
    require => Package['npm'],
  }

  # http://gulpjs.com
  exec { 'gulp-cli':
    command => 'npm install -g gulp-cli',
    require => Package['npm'],
  }

  # http://webpack.github.io
  exec { 'webpack':
    command => 'npm install -g webpack',
    require => Package['npm'],
  }

  # https://bower.io
  exec { 'bower':
    command => 'npm install -g bower',
    require => Package['npm'],
  }

  # http://eslint.org
  exec { 'eslint':
    command => 'npm install -g eslint',
    require => Package['npm'],
  }

  # http://jspm.io
  exec { 'jspm':
    command => 'npm install -g jspm',
    require => Package['npm'],
  }

  # https://www.typescriptlang.org
  exec { 'typescript':
    command => 'npm install -g typescript',
    require => Package['npm'],
  }

  # https://babeljs.io
  exec { 'babel-cli':
    command => 'npm install -g babel-cli',
    require => Package['npm'],
  }
}
