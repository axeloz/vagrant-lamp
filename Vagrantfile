# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "axeloz/ubuntu-server-16.04"


  #config.ssh.private_key_path="~/.ssh/id_rsa"
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'
  config.ssh.forward_agent = true

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Default HTTP port
  config.vm.network "forwarded_port", guest: 80, host: 8080
  # Additional HTTP port for PHP Serve or other
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 8082, host: 8082
  # MySQL port
  config.vm.network "forwarded_port", guest: 3307, host: 3306
  # Postfix SMTP port
  config.vm.network "forwarded_port", guest: 25, host: 2525
  # Mailcatcher SMTP port
  config.vm.network "forwarded_port", guest: 1025, host: 1025
  # Mailcatcher HTTP port
  config.vm.network "forwarded_port", guest: 1080, host: 1080
  # BrowserSync port
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3001, host: 3001

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.99.100"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ['actimeo=2']

  #config.vm.synced_folder "./www", "/vagrant/www", type: "nfs"
  #config.vm.synced_folder "./mysql", "/vagrant/mysql", type: "nfs"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
     #vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "1024"
    vb.name = "w_vagrant_lamp"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "lamp"
  end

  config.vm.provision "shell", run: 'always', inline: <<-SHELL
    service apache2 start
    service mysql start
  SHELL




end
