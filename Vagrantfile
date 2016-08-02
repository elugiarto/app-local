#
# Vagrant Configuration, https://www.vagrantup.com.
#

require 'yaml'

Vagrant.configure(2) do |config|

  developer = {}

  #
  # Load developer config to customise vm and define mapped folders.
  #
  if File.exist? 'hiera/developer.yaml'
    developer = YAML.load(File.open('hiera/developer.yaml'))
  end

  #
  # If you have issues with failed authentication messages duing vm setup, uncomment this line.
  #
  if developer.has_key? 'disable_ssh_key_insert' and developer['disable_ssh_key_insert'] == true
    config.ssh.insert_key=false
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

    app.vm.network 'forwarded_port', guest: 443, host: 8443, host_ip: '127.0.0.1'
    app.vm.network 'forwarded_port', guest: 3306, host: 3306, host_ip: '127.0.0.1'

    if developer.has_key? 'projects'
      developer['projects'].each_pair do |to, from|
        app.vm.synced_folder File.expand_path(from['source'], File.dirname(__FILE__)), "/app/source/#{to}"
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
