# VAGRANT LAMP ENVIRONMENT


## Description

This repository provides a starter kit that you to download in order to get a fully fonctional **Ubuntu Server 16.04 LTS** (headless) LAMP local development environment on top of Vagrant.

In order to do so, the starter kit uses a virtualization application (**VirtualBox**), a virtualization wrapper (**Vagrant**) and a recipes manager (**Chef Solo**). See "Installation" below.

The Vagrant Virtual Machine (or VM) will run on Ubuntu Server. The **box image used was created by me**. It is hosted on VagrantUp as `axeloz/ubuntu-server-16.04` (https://app.vagrantup.com/axeloz/boxes/ubuntu-server-16.04). It is a clean install of Ubuntu with just a little bit of configuration in it. You may change the box used by Vagrant and use your own (at your own risks) by editing the `config.vm.box` setting into the `Vagrantfile` at the root of this repository.

Using one command only, a LAMP environment is installed on your computer among all the required tools for your developments. The Vagrant Virtual Machine (or VM) can be stopped when you don't need it and started when you need it.

### ⚠ Attention ⚠

You must understand that you can do whatever you want with the Vagrant Virtual Machine (or VM) like adding files, removing anything, installing new applications using APT or compilation. But be aware that the VM is not supposed to be persistent. The persistent data **are and should remain on your host computer**. The VM is throwable, you may mess with it, crash it, remove it and recreate it brand as new. It is that simple as `vagrant destroy && vagrant up`.


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
- MariaDB (https://mariadb.org/)
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
- Clone the latest version of this repository (https://github.com/axeloz/vagrant-lamp) into your Home directory, whereever you want it to be. For example for Mac: `/Users/my-user/Sites/vagrant-lamp`
- Open your terminal app, `cd` to the vagrant directory
- Run a `vagrant up` command. For the first run, Vagrant will download the Linux Ubuntu 16.04 image from VagrantUp, create a new VirtualBox VM, boot the VM and run the Chef recipes. This will install all the dependencies, it may take some time. 
- Optionally, you can install Vagrant Manager (http://vagrantmanager.com/) which is a GUI to manage your Vagrant VMs.

### ⚠ Attention ⚠

**For Mac and Unix systems**
When starting the VM, Vagrant will create a mount point between the VM and the host computer. On the VM, the mount point is made on `/vagrant`. 
Mounting is done using NFS for security and performance purposes. **Vagrant will require your host computer password** in order mount the folder. I **do not** ask for this password and I **do not** have access to this password. This password is asked by your computer in order to run a command as `sudoer`. 

If you want to avoid typing your password each time you start your VM, you can edit the `sudoers` file and allow permanently Vagrant to mount NFS folders without password. In your terminal application on your host computer, edit the `/etc/sudoers` file with `sudo`. Then paste the following lines at the end of the file:

```
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE
```

You might have to logout and login back on your computer to apply these changes. Then next time you boot your VM, it should mount the NFS directly, no password asked.

## Upgrade

In order to upgrade, just:
- `git pull` at the root of the vagrant-lamp folder
- `vagrant reload --provision`

## Accessing the tools

- To SSH into the VM, run the `vagrant ssh` command from the root of the vagrant-lamp folder. The login is `vagrant` and the password is `vagrant`
- To sudo in the VM, just run `sudo <command>`. The `vagrant` user belongs to the sudoers and you may `sudo` with no password asked
- The IP address `192.168.99.100` is created by VM
- The VM is also available on hostname `localhost`
- In order to acccess your local websites: http://localhost:8080
- In order to access Mailcatcher: http://localhost:1080
- In order to access to MariaDB: mysql://vagrant:vagrant@localhost:3306
- In order to access the Mailcatcher's SMTP from the host: smtp://localhost:1025
- In order to access BrowserSync from the host: http://localhost:3000
- In order to use Drush, run the `drush` command from the VM
- In order to use WP_CLI, run the `wp` command from the VM
- In order to use DEPLOYER, run the `dep` command from the VM
- In order to use GULP, run the `gulp` command from the VM

## The tools in detail

### Apache

#### Access
Your local environment is available from your host computer at the address: http://localhost:8080. This will launch a default application that will:
- list all your projects 
- show the PHP configuration
- show the server informations

#### Dedicated Apache virtual host

In some cases, you might need to create a dedicated virtual host to access your project. For example: http://myproject.local:8080. 

**For Mac and Unix systems:** In order to do so, a script `create-vhost.sh` is provided to the root of the repository. Make sure it is executable (`chmod +x create-vhost.sh`) and run it (`./create-vhost.sh`). Just following the instructions, the script will then create an entry into the `/etc/hosts` file and add the virtual host to Apache into the `vagrant-lamp/apache/conf` folder. 

**In any case:** You may also do it manually by creating the Apache virtual host configuration file into the `vagrant-lamp/apache/conf`. Attention: the file must be named with a `.conf` suffix. 
You must also add manually an entry into the `hosts` file. 
Finally you must reload Apache on the VM machine using `service apache2 reload`.

#### Mailcatcher test form

You may also access the http://localhost:8080/mail.php page. This is a test form allowing you to test the Mailcatcher application.

The Apache log files are located into the `vagrant-lamp/apache/logs` folder.


### MariaDB (MySQL)

The root user for MariaDB is:
- login: vagrant
- password: vagrant

As usual, the MariaDB data are located on the host computer into the `vagrant-lamp/mysql/data` folder. 

The MariaDB log files are located into the `vagrant-lamp/mysql/logs`

### Gulp

## Questions / Know issues

### Files watching
Because of VirtualBox, the `watch` command (for Laravel for example) may not work as expected. The `watch` command is running on the VM but the source files are located on the host computer and mounted using NFS. The `watch` command cannot therefore use default Unix feature. You should use the `watch-poll` command instead (for Laraval). You may have similar issues with `gulp watch` or `browsersync`.
