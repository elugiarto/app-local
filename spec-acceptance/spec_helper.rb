require 'serverspec'
require 'nokogiri'
require 'open-uri'
require 'net/https'

# TODO: Is this not 443 internally? If not, this will need to be based on site config.
SITE = 'https://localhost:8443'

def get_doc_ignore_ssl url
  Nokogiri::HTML(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
end
