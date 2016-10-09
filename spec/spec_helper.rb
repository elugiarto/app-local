require 'serverspec'
require 'nokogiri'
require 'open-uri'
require 'net/https'

SITE = 'https://localhost:8443'

def get_doc_ignore_ssl url
  Nokogiri::HTML(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
end
