#
# Cookbook Name:: lamp
# Recipe:: default
#


#####################################
# VARIOUS TOOLS
#####################################
package 'nano'
package 'multitail'
package 'telnet'
package 'apt-transport-https'
package 'build-essential'
package 'curl'
package 'unzip'
package 'lsb-release'
package 'ca-certificates'

#####################################
# NTPDATE
#####################################
package 'ntpdate'
template '/etc/cron.daily/ntpdate' do
  source 'ntpdate_cron'
end


#####################################
# PHP
#####################################

apt_repository 'php7' do
	action :add
	uri 'ppa:ondrej/php'
	distribution node['lsb']['codename']
	cache_rebuild true
end

package 'php7.1'
package 'php7.1-curl'
package 'php7.1-dev'
package 'php7.1-gd'
package 'php7.1-json'
package 'php7.1-mysql'
package 'php7.1-readline'
package 'php7.1-xml'
package 'php7.1-intl'
package 'php7.1-mbstring'
package 'php7.1-mcrypt'
package 'php-xdebug'
package 'php7.1-zip'
package 'php7.1-sqlite3'
package 'php7.1-msgpack'
package 'php7.1-gmp'
package 'php7.1-geoip'
package 'php7.1-redis'


#####################################
# MEMCACHE
#####################################
package 'memcached'
package 'php7.1-memcached'

service 'memcached' do
  action [:enable, :start]
end


#####################################
# APACHE
#####################################
package 'apache2'
package 'libapache2-mod-php7.1'

template '/etc/apache2/conf-enabled/users.conf' do
  source 'users.conf'
end

template '/etc/apache2/sites-enabled/000-default.conf' do
  source 'apache-000_default.conf.erb'
  manage_symlink_source true
end

template '/etc/php/7.1/apache2/php.ini' do
  source 'php.ini.erb'
end

execute 'enable_modrewrite' do
	user 'root'
	command '/usr/bin/env a2enmod rewrite'
	creates '/etc/apache2/mods-enabled/rewrite.load'
end

service 'apache2' do
  supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
  action [:enable, :reload]
end

#####################################
# GIT
#####################################
package 'python-software-properties'

apt_repository 'git-core' do
	action :add
	uri 'ppa:git-core/ppa'
	distribution node['lsb']['codename']
	cache_rebuild true
end

execute 'install_git_repo' do
	user 'root'
	command 'curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash'
	creates '/usr/bin/git-lfs'
end

package 'git'
package 'git-lfs'


#####################################
# COMPOSER
#####################################
execute 'install_composer' do
	user 'root'
	command 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer'
	creates '/usr/local/bin/composer'
end


#####################################
# MYSQL
#####################################

package 'mariadb-server'
package 'mariadb-client'

template '/etc/init.d/mysql' do
	source 'mysql-init-d'
end

template '/etc/mysql/mariadb.conf.d/50-server.cnf' do
  source 'mysql-50-server.cnf'
end

directory '/var/run/mysqld' do
  user 'root'
	action :create
	owner 'vagrant'
	group 'vagrant'
	mode '0775'
end

service 'mysql' do
  supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
  action [:enable, :reload]
end

execute 'mysql_create_databases' do
	user 'vagrant'
	notifies :stop, 'service[mysql]', :before
	command '/usr/bin/env mysql_install_db'
	creates '/vagrant/mysql/data/mysql'
	notifies :start, 'service[mysql]', :immediately
end

execute 'mysql_create_user' do
	command '/usr/bin/env mysql -uroot -e "CREATE USER \'vagrant\'@\'%\' IDENTIFIED BY \'vagrant\'; GRANT ALL PRIVILEGES ON *.* TO \'vagrant\'@\'%\' WITH GRANT OPTION;"'
	not_if '/usr/bin/env mysql -uroot -e "SELECT User FROM mysql.user WHERE User = \'vagrant\'" |grep vagrant'
end


#####################################
# NODEJS
#####################################
execute 'install_nodejs' do
	user 'root'
	command 'curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -'
	creates '/usr/bin/nodejs'
end
package 'nodejs'


#####################################
# MAILCATCHER
#####################################
package 'bundler'
package 'libsqlite3-dev'
gem_package 'mailcatcher'

user 'mailcatcher' do
  comment 'The mailcatcher user'
  system true
  action :create
end

template '/etc/init.d/mailcatcher' do
  source 'mailcatcher'
end

file '/etc/init.d/mailcatcher' do
	mode '0755'
	owner 'root'
	group 'root'
end

service 'mailcatcher' do
	action [:enable, :start]
end

#####################################
# WP_CLI
#####################################
bash 'install_wpcli' do
	code <<-EOH
		/usr/bin/env curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		if [ $? -eq 0 ] && [ -f "wp-cli.phar" ]; then
			chmod +x wp-cli.phar
			mv wp-cli.phar /usr/local/bin/wp
		fi
	EOH
	creates '/usr/local/bin/wp'
end

#####################################
# DRUSH
#####################################
# Installs drush@8.1.10
bash 'install_drush' do
  code <<-EOH
    /usr/bin/env curl -sLO https://github.com/drush-ops/drush/releases/download/8.1.10/drush.phar
    if [ $? -eq 0 ] && [ -f "drush.phar" ]; then
      chmod +x drush.phar
      mv drush.phar /usr/local/bin/drush
    fi
  EOH
  creates '/usr/local/bin/drush'
end

#####################################
# DRUPAL CONSOLE
#####################################
bash 'install_drupal_console' do
	code <<-EOH
		php -r "readfile('https://drupalconsole.com/installer');" > drupal.phar
		if [ $? -eq 0 ] && [ -f "drupal.phar" ]; then
			chmod +x drupal.phar
			mv drupal.phar /usr/local/bin/drupal
		fi
	EOH
	creates '/usr/local/bin/drupal'
end


#####################################
# BROWSER SYNC
#####################################
execute 'install_browsersync' do
	user 'root'
	command 'npm install -g browser-sync'
	creates '/usr/bin/browser-sync'
end


#####################################
# NPM
#####################################
execute 'install_gulp' do
	user 'root'
	command 'npm install -g npm'
	creates '/usr/bin/npm'
end


#####################################
# BOWER
#####################################
execute 'install_bower' do
	user 'root'
	command 'npm install -g bower'
	creates '/usr/bin/bower'
end


#####################################
# REDIS
#####################################
package 'redis-server'
service 'redis-server' do
	action [:enable, :start]
end


#####################################
# MONGODB
#####################################
package 'mongodb'
service 'mysql' do
  action [:enable, :start]
end


#####################################
# SUPERVISOR
#####################################
package 'supervisor'
service 'supervisor' do
  action [:enable, :start]
end


#####################################
# SASS
#####################################
gem_package 'sass'
