#
# Defines the Node specification.
#

require_relative '../spec_helper'

describe command('node --version') do
  its(:stdout) { should match /^v6.9.+/ }
end

describe command('npm --version') do
  its(:stdout) { should match /^3.10.+/ }
end
