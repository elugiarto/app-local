#
# Defines the Oracle Tools specification.
#

require_relative '../spec_helper'

describe 'OCI8 present in php configuration.' do
  about_document = get_doc_ignore_ssl("#{SITE}/about.php")

  it { !!(/^oci8+$/ =~ about_document.xpath('//a[contains(@name, "module_oci8")]').first.content) }
end
