#
# Defines the Apache PHP specification.
#

require 'nokogiri'
require 'open-uri'
require 'net/https'
require_relative '../spec_helper'

describe port(443) do
  it { should be_listening }
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

describe 'PHP about page "/about.php"' do

  url = 'https://localhost:8443/about.php'
  doc = Nokogiri::HTML(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

  it { !!(/^PHP Version 5\.5\.\d+$/ =~ doc.xpath('//h1').first.content) }
end
