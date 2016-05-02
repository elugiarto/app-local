#
# Vagrant Configuration, https://www.vagrantup.com.
#

require 'yaml'

Vagrant.configure(2) do |config|

  developer = {}

  #
  # Load developer config to customise vm and define mapped folders.
  #
  if File.exist? 'developer.yaml'
    developer = YAML.load(File.open('developer.yaml'))
  end

  #
  # Get CentOS Box, https://atlas.hashicorp.com/puppetlabs/boxes/centos-7.2-64-puppet/versions/1.0.1.
  #
  config.vm.box = 'puppetlabs/centos-7.2-64-puppet'
  config.vm.box_version = '1.0.1'

  #
  # Vagrant Puppet Install, https://github.com/petems/vagrant-puppet-install.
  #
  config.puppet_install.puppet_version = '4.4.0'

  #
  # Vagrant VM Config, https://www.vagrantup.com/docs/multi-machine/.
  #
  config.vm.define 'localhost' do |app|
    app.vm.hostname = 'localhost'
    developer_machine_port = 8443
    vm_port = 443
    mysql_port = 3306
    app.vm.network 'forwarded_port', guest: vm_port, host: developer_machine_port, host_ip: '127.0.0.1', auto_correct: true
    app.vm.network 'forwarded_port', guest: mysql_port, host: mysql_port, host_ip: '127.0.0.1', auto_correct: true

    if developer.has_key? 'projects'
      developer['projects'].each_pair do |to, from|
        app.vm.synced_folder File.expand_path(from, File.dirname(__FILE__)), "/app/#{to}"
      end
    end
  end

  #
  # Running the Puppet Apply command.
  #
  config.vm.provision 'shell' do |shell|
    modules = '/vagrant/modules'
    app_modules = '/vagrant/app_modules'
    manifest = "#{app_modules}/app/manifests/local.pp"
    hiera_config = '/vagrant/hiera/hiera.yaml'

    shell.inline = "puppet apply --hiera_config=#{hiera_config} --modulepath=#{modules}:#{app_modules} #{manifest}"
  end
end
