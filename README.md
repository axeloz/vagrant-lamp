# VAGRANT LAMP ENVIRONMENT


## Description

This repository contains a starter kit providing a fully functional **Ubuntu Server 16.04 LTS** (headless) LAMP local development environment on top of Vagrant.

This starter kit uses a virtualization application (**VirtualBox**), a virtualization wrapper (**Vagrant**) and a recipes manager (**Chef Solo**). See "[Installation](#installation)" below.

The Vagrant Virtual Machine (or VM) will run a Ubuntu Server instance. The **box image used was created by me**. It is hosted on VagrantUp as [axeloz/ubuntu-server-16.04](https://app.vagrantup.com/axeloz/boxes/ubuntu-server-16.04). It is a clean install of Ubuntu with just a little bit of configuration in it. You may use a different box or use your own by editing the `config.vm.box` setting into the [Vagrantfile](https://github.com/axeloz/vagrant-lamp/blob/master/Vagrantfile). I highly recommend to use an Ubuntu distribution. It might also work on Debian but this is untested. Changing the Vagrant box is at your own risk as I cannot guaranty the compatibility. 

### Why should I use this starter kit?

Using one command only, a LAMP environment is installed on your computer among all the required tools for your developments. The Vagrant Virtual Machine (or VM) can be stopped when you don't need it and started when you need it.

More tools can be added very easily if you need to. Just edit the [recipe](https://github.com/axeloz/vagrant-lamp/blob/master/cookbooks/lamp/recipes/default.rb) and build your own VM according to your needs.

The VM is disposable. All the data remains on the host computer. Just backup the host computer, you are sure not to loose anything (sources, databases, configuration files...). 
Did the VM crashed because you messed up with it? Just destroy it and restart it. You're good to go in no time.

You may adapt the services configuration (like PHP for example) according to your needs. Just edit the [php.ini.erb](https://github.com/axeloz/vagrant-lamp/blob/master/cookbooks/lamp/templates/default/php.ini.erb) file, run a `vagrant provision` and you're good to go.

For your team, it guaranties that all developers are using the exact same environment. Plus you get rid of the pain of installing a Linux environment from scratch. Let's say that a new developer joins the team, he's ready to dig into your projects in no time.
Finally, the team members can run a `vagrant provision` in order to apply any recipe update if applicable. This is very convenient when the lead developer adds a new tool in the recipes, it can be deployed for the entire team with no hassle.

### ⚠ Attention ⚠

You must understand that the VM is meant to be disposable, it is not supposed to be persistent. Any persistent data **should remain on your host computer**, do not apply changes to the VM nor store data or documents that you don't want to loose. 

As a consequence, you may mess up with the VM, do heavy testing, install new apps to evaluate them and even crash it. If you need to rollback, just destroy it and recreate it as pure as the driven snow. It is as simple as a `vagrant destroy && vagrant up`.

Also this starter kit was tested and used on a Apple computer. It supposed on any system but this is **untested**. 
Let me know if you encounter any issue.

## Content of the starter kit

- Apache2 (http://www.apache.org)
- Bower (https://bower.io)
- Composer (https://getcomposer.org/)
- Bundler (http://bundler.io)
- Browser Sync (https://www.browsersync.io)
- CURL (https://curl.haxx.se)
- Deployer (https://deployer.org)
- Drush@8.1.10 (https://github.com/drush-ops/drush)
- Drupal Console (https://drupalconsole.com/)
- Git (https://git-scm.com/)
- Git-LFS (https://git-lfs.github.com)
- Gulp (http://gulpjs.com/)
- PHP7 (http://www.php.net) :
    - CURL
    - Dev
    - GD
    - Json
    - MySQL
    - Readline
    - XML
    - Intl
    - Mbstring
    - Mcrypt
    - Xdebug
    - Zip
    - Sqlite3
    - Memcached
- Mailcatcher (https://mailcatcher.me/)
- MariaDB (MySQL) (https://mariadb.org/)
- Memcached (http://www.memcached.org/)
- MongoDB (https://www.mongodb.com/)
- Multitail (https://www.vanheusden.com/multitail/)
- Nano
- NodeJS 7 (https://nodejs.org/en/) et NPM (https://www.npmjs.com/)
- NTPDate
- Redis (https://redis.io/)
- SASS (http://sass-lang.com)
- Sqlite3
- Unzip
- WP_Cli (http://wp-cli.org/)
- XDebug (https://xdebug.org/)

## Installation

- Download and install VirtualBox (http://www.virtualbox.org/)
- Download and install Vagrant (https://www.vagrantup.com/)
- Clone the latest version of this repository (https://github.com/axeloz/vagrant-lamp) into your Home directory, wherever you want it to be. For example for Mac: `/Users/my-user/Sites/vagrant-lamp`
- Open your terminal app, `cd` to the `vagrant-lamp` directory
- Run a `vagrant up` command. During the first boot, Vagrant will download the Linux Ubuntu 16.04 box from VagrantUp, create a new VirtualBox VM, boot the VM and run the Chef recipes. This will install all the dependencies, it may take some time. 
- Optionally, you can install Vagrant Manager (http://vagrantmanager.com/) which is a GUI to manage your Vagrant VMs.

### ⚠ Attention for Mac and Unix systems ⚠

When starting the VM, Vagrant will create a mount point between the VM and the host computer. On the VM, the mount point is made on `/vagrant` and will contain the entire `vagrant-lamp` folder.

Mounting is done using NFS for security and performance purposes. **Vagrant will require your host computer password** in order mount the folder. I **do not** ask for this password myself and I **do not** have access to this password. This password is asked by your computer in order to run a command as `sudo`. 

If you want to avoid typing your password each time you start your VM, you can edit the `sudoers` file and allow Vagrant to mount NFS folders without requiring any password. In your terminal application on your host computer, edit the `/etc/sudoers` file with `sudo`. Then paste the following lines at the end of the file:

```
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE
```

You might have to logout and login back to your computer to apply these changes. Then next time you boot your VM, it should mount the NFS directly, no password asked.

## Upgrade

In order to upgrade, just:
- `git pull` at the root of the vagrant-lamp folder
- `vagrant reload --provision`

## Accessing the tools

- To SSH into the VM, run the `vagrant ssh` command from the root of the `vagrant-lamp` folder. The login is `vagrant` and the password is `vagrant`
- To sudo in the VM, just run `sudo <command>`. The `vagrant` user belongs to the sudoers and you may `sudo` with no password asked
- The IP address `192.168.99.100` is created by VM
- The VM is also available on hostname `localhost`
- In order to access your local websites: http://localhost:8080
- In order to access Mailcatcher: http://localhost:1080
- In order to access to MariaDB: mysql://vagrant:vagrant@localhost:3307
- In order to access the Mailcatcher's SMTP from the host: smtp://localhost:1025
- In order to access BrowserSync from the host: http://localhost:3000
- In order to use Drush, run the `drush` command from the VM
- In order to use WP_CLI, run the `wp` command from the VM
- In order to use DEPLOYER, run the `dep` command from the VM
- In order to use GULP, run the `gulp` command from the VM

## The features in detail

### SSH

You may access the VM using SSH using the `vagrant ssh` command. 
There is an existing Unix user:
- login: vagrant
- password: vagrant

The SSH identity forwarding is enabled from the host to the VM (`config.ssh.forward_agent = true`). This means that your host's computer SSH identity is forwarded to the VM. That may be useful in many cases. For example, you clone a Github repository to your host computer using the host's SSH public key attached to your Github account. With the identify forwarding enabled, you can SSH to the VM, `cd` to the downloaded repository and run a `git pull`. It will use your host computer's keypair. There is no need to add a new public key on your Github account.

### Apache

#### Access
Your local environment is available from your host computer at the address: http://localhost:8080. This will launch a default application that will:
- list all your projects 
- show the PHP configuration
- show the server information

The default document root is: `/vagrant/www`

#### Dedicated Apache virtual host

In some cases, you might need to create a dedicated virtual host to access your projects. For example: http://myproject.local:8080. 

For Mac and Unix systems: in order to do so, the script [create-vhost.sh](https://github.com/axeloz/vagrant-lamp/blob/master/create-vhost.sh) is provided. Make sure it is executable (`chmod +x create-vhost.sh`) and run it from the **host** (`./create-vhost.sh`). Just follow the instructions, the script will then create an entry into the `/etc/hosts` file and will add the virtual host to Apache into the `vagrant-lamp/apache/conf` folder. Finally, it will reload Apache. 

In any case: you can also do it manually by creating the Apache virtual host configuration file into the `vagrant-lamp/apache/conf`. Attention: the file must be named with a `.conf` suffix. 
You must also add manually an entry into the computer's `hosts` file. 
Finally, you must reload Apache on the VM machine using `service apache2 reload`.

#### Projects browser

This starter kit comes with a homemade projects browser. To access this browser, simply visit http://localhost:8080 from your host Web browser. 
The project browser will show the content of the `/vagrant/www` directory and allow you to navigate into the subfolders. 

[The projects browser](https://github.com/axeloz/vagrant-lamp/raw/master/screenshot.png)

#### Mailcatcher test form

You may also access the http://localhost:8080/mail.php page. This is a test form allowing you to test the Mailcatcher application.

#### Log files

The Apache log files are located into the `vagrant-lamp/apache/logs` folder.

### MariaDB (MySQL)

#### Access

MariaDB is running on port 3306 on the VM. 
There is a port redirection from the host to the VM: host:3307 -> vm:3306. 

The root user for MariaDB is:
- login: vagrant
- password: vagrant

#### Data location

As usual, the MariaDB data are located on the host computer into the `vagrant-lamp/mysql/data` folder. 

#### MariaDB logs

The MariaDB log files are located into the `vagrant-lamp/mysql/logs`

### Gulp

Please refer to the chapter [File changes watcher](#file-changes-watcher)".

## Questions / Know issues

### Issues at boot time

You may encounter some issues at boot time. I'm still unsure why as it works on my Mac but I have seen it fail occasionally on other computers. 

- issue with APT: there seem to be a conflict when the Ubuntu box starts automatically an `apt-get upgrade` command after boot. It prevents the Chef recipe to also call the `apt` command as there can be only one upgrade process at a time. I tried to disable the automatic upgrade on the box. Let me know if this occurs.
- issue with MariaDB: for some reasons, the permissions on the `/var/run/mysqld` folder are incorrect despite I fix them during the recipes. As a consequence, MariaDB refuses to boot. To fix manually, SSH to the VM, run a `chown -R vagrant:vagrant /var/run/mysqld` command and try restarting MariaDB. Let me know if this occurs to you or if you know how to fix this once for all.
- issue with port forwarding: Vagrant will create port forwarding between the host and the VM services. If a port is already in use on the host, booting the VM might fail. To fix, you can either stop the service on the host computer or change the host's port in the `Vagrantfile.

For any other unlisted issue, please add a ticket on Github: https://github.com/axeloz/vagrant-lamp/issues

### Mailcatcher

Mailcatcher is supposed to be started when the VM boots. For some reason, this is not always the case. In order to start Mailcatcher manually, SSH to the VM and run a `killall mailcatcher && mailcatcher --no-quit --ip 0.0.0.0`

### File changes watcher

When you run a file changes watcher on the VM, the `watch` command is running on the VM but the watched files are located on the host computer and mounted using NFS on the VM. For this reason, the watcher does not always catch file changes properly. I tried to fix this issue, let me know if you come accross this matter.


## Contributing

You are welcome to help and contribute to this repository.
