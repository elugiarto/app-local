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

    listen_https = 8443
    listen_mysql = 3306

    if developer.has_key? 'listen_ports'
      listen_https = developer['listen_ports']['https']
      listen_mysql = developer['listen_ports']['mysql']
    end

    app.vm.network 'forwarded_port', guest: 443, host: listen_https, host_ip: '127.0.0.1'
    app.vm.network 'forwarded_port', guest: 3306, host: listen_mysql, host_ip: '127.0.0.1'

    if developer.has_key? 'projects'
      developer['projects'].each_pair do |to, from|
        app.vm.synced_folder File.expand_path(from['source'], File.dirname(__FILE__)), "/app/source/#{to}"
      end
    end
  end

  #
  # Update hosts file to define "puppet" domain in hosts file as 127.0.0.1.
  #
  config.vm.provision 'shell', inline: 'cp /vagrant/app_modules/app_local/files/hosts /etc/hosts && systemctl restart puppet'

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

  #
  # ServerSpec testing, only enabled for acceptance testing purposes.
  #
  if developer.has_key? 'enable_server_spec' and developer['enable_server_spec'] == true
    config.vm.provision 'serverspec' do |spec|
      spec.pattern = './spec/localhost/*'
    end
  end
end
