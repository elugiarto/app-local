#
# Defines the Node specification.
#

require_relative '../spec_helper'

describe command('node --version') do
  its(:stdout) { should match /^v7\..+/ }
end

describe command('npm --version') do
  its(:stdout) { should match /^4\..+/ }
end
