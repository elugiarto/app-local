#
# Defines the Oracle Tools specification.
#

require_relative '../spec_helper'

# describe 'OCI8 present in php configuration.' do
#   about_document = get_doc_ignore_ssl("#{SITE}/about.php")
#   content_match = about_document.xpath('//a[contains(@name, "module_oci8")]').first.content
#
#   it { (/^oci8+$/ =~ content_match) }
# end

describe 'OracleXE Database' do
  describe port(1521) do
    it { should be_listening }
  end

  # TODO: How to confirm that it is oraclexe listening on this port?
end
