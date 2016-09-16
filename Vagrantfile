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
  # Handle errors with ssh key insertion.
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

    listen_ports = {}

    #
    # Custom port mapping configuration.
    #
    if developer.has_key? 'listen_ports'
      listen_ports['https'] = developer['listen_ports']['https']
      listen_ports['mysql'] = developer['listen_ports']['mysql']
      listen_ports['oracle_xe'] = developer['listen_ports']['oracle_xe']
      listen_ports['oracle_xe_web'] = developer['listen_ports']['oracle_xe_web']
    else
      listen_ports['https'] = 8443
      listen_ports['mysql'] = 3306
      listen_ports['oracle_xe'] = 1521
      listen_ports['oracle_xe_web'] = 8888
    end

    app.vm.network 'forwarded_port', guest: 443, host: listen_ports['https'], host_ip: '127.0.0.1'
    app.vm.network 'forwarded_port', guest: 3306, host: listen_ports['mysql'], host_ip: '127.0.0.1'

    if developer.has_key? 'enable_oracle_xe' and developer['enable_oracle_xe'] == true
      app.vm.network 'forwarded_port', guest: 8888, host: listen_ports['oracle_xe'] , host_ip: '127.0.0.1'
      app.vm.network 'forwarded_port', guest: 1521, host: listen_ports['oracle_xe_web'], host_ip: '127.0.0.1'
    end

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
    manifest = "#{app_modules}/app_local/manifests/local.pp"
    hiera_config = '/vagrant/hiera/hiera.yaml'

    shell.inline = "puppet apply --hiera_config=#{hiera_config} --modulepath=#{modules}:#{app_modules} #{manifest}"
  end
end
