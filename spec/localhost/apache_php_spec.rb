#
# Defines the Apache PHP specification.
#

require_relative '../spec_helper'

describe port(443) do
  it { should be_listening }
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

describe 'PHP about page "/about.php"' do
  about_document = get_doc_ignore_ssl("#{SITE}/about.php")
  expected_version = /^PHP Version 5\.5\.\d+$/

  it { !!(expected_version =~ about_document.xpath('//h1').first.content) }
end
