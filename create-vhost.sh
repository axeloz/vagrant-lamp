#!/bin/bash

function error {
	echo "$(tput setaf 1) ! $1$(tput sgr 0)"
}

function success {
	echo "$(tput setaf 2)$1$(tput sgr 0)"
}

currentdir=`pwd`


who=`whoami`
if [ "$who" = "vagrant" ]
then
	error "This script is supposed to be run from the host, not from the guest"
	exit 1
fi


echo
echo "= APPLICATION CONFIGURATION ="
echo

success "We have detected the following path for the Vagrant root:"
success " > $currentdir"


# Checking Vagrant root path
echo
while true
do
	read -p "Is that correct? [Y/n] " correct

	if [ "$correct" = "y" ] || [ -z "$correct" ]
	then
		correct="y"
		break
	elif [ "$correct" = "n" ]
	then
		break
	else
		error "You must answer the question using 'y' or 'n'"
	fi
done

# Vagrant root path must be fixed
if [ "$correct" = "n" ]
then
	while true
	do
		read -p "Please enter the Vagrant root path: " vagrantroot

		if [ -z "$vagrantroot" ]
		then
			error "Vagrant root cannot be empty"
		elif [ ! -d "$vagrantroot" ]
		then
			error "The Vagrant root '$vagrantroot' does not exist"
		elif [ ! -d "$vagrantroot/apache/conf" ]
		then
			error "Could not find the Apache conf directory in '$vagrantroot/apache/conf'"
		else
			success "Thank you!"
			break
		fi
	done
elif [ "$correct" = "y" ] || [ -z "$correct" ]
then
	success "Thank you!"
	vagrantroot=$currentdir
else
	error "You must answer the question using 'y' or 'n'"
fi

# Checking whether Vagrant machine is running
echo
echo "= CHECKING VAGRANT MACHINE STATUS ="
cd $vagrantroot
cmd=`vagrant status |grep "running" > /dev/null 2>&1`

if [ $? -ne 0 ]
then
	error "The Vagrant machine does not seem to be in running state"

	while true
	do
		read -p "Do you want to start the machine? This is mandatory in order to run this app [Y/n] " startmachine
		if [ -z "$startmachine" ]
		then
			startmachine="y"
		fi

		if [ "$startmachine" != "y" ] && [ "$startmachine" != "n" ]
		then
			error "Please answer with 'y' or 'n'"
		else
			if [ "$startmachine" = "y" ]
			then
				success "Thank you! Now starting machine"
				vagrant up
				break
			else
				success "Thank you! Unfortunately, I must leave you now..."
				exit 0
			fi
		fi
	done
else
	success "The Vagrant machine is running"
fi


# Getting the site hostname
append=false
echo
while true
do
	read -p "What is the subdomain of \"vagrant.vm\" would you like to add? " hostname

	if [ -z "$hostname" ]
	then
		error "The subdomain cannot be empty, please retry..."
	else
		hostname=
	elif [ -f "$vagrantroot/apache/conf/$hostname.conf" ]
	then
		error "The configuration file '$vagrantroot/apache/conf/$hostname.conf' already exists."
		echo
		echo "What should I do?"

		PS3='Please enter your choice: '
		options=("Show" "Overwrite" "Append" "Abort")
		select opt in "${options[@]}"
		do
			case $opt in
				"Abort")
					success "OK, bye!"
					exit 0
					;;
				"Show")
					success "Sure thing! Here is the content of the file:"
					echo
					cat $vagrantroot/apache/conf/$hostname.conf

					if [ $? -ne 0 ]
					then
						error "Cannot get the configuration file content"
					fi
					echo
					;;
				"Overwrite")
					rm -f "$vagrantroot/apache/conf/$hostname.conf"
					if [ $? -ne 0 ]
					then
						error "Could not remove existing configuration file. You should do it manually..."
					else
						success "Existing configuration file was removed"
					fi
					echo
					break 2
					;;
				"Append")
					append="true"
					success "OK, the new configuration will be added to the existing file"
					echo
					break 2
					;;
				*) error "Please choose a valid option";;
			esac
		done
	else
		success "Thank you!"
		break
	fi
done

# Getting the site path
echo
while true
do
	read -p "What is the path of the vhost you want to add? /vagrant/www/" path

	if [ -z "$path" ]
	then
		error "The path cannot be empty, please retry..."
	else
		path="/vagrant/www/$path"
		vagrant ssh -c "ls $path" > /dev/null 2>&1

		if [ $? -ne 0 ]
		then
			error "Directory '$path' does not exist on Vagrant"
		else
			success "Thank you!"
			break
		fi
	fi
done

# Getting vhost public document root path
echo
while true
do
	read -p "What is the public document root path? $path/" public

	if [ -z "$public" ]
	then
		public=$path
		success "Thank you!"
		break
	else
		public="$path/$public"
		vagrant ssh -c "ls $public" > /dev/null 2>&1

		if [ $? -ne 0 ]
		then
			error "Directory '$public' does not exist on Vagrant"
		else
			success "Thank you!"
			break
		fi
	fi
done

# All configuration done, executing...
echo
success "Thank you, everything is now fine. We are processing your request"
echo


# Managing the Apache configuration
echo
echo "= ADDING VHOST TO APACHE ="
vhost="<VirtualHost *:80>
	ServerName $hostname.vagrant.vm
	DocumentRoot $public
	<Directory $path>
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>"

sudo -- sh -c -e "echo '$vhost' >> $vagrantroot/apache/conf/$hostname.conf"


if [ $? -ne 0 ]
then
	error "Could not create the '$vagrantroot/apache/conf/$hostname.conf' file automatically"
	error "You should create it with the following line manually:"
	error "$vhost"
else
	success "Hostname successfully added to host's file"
fi

echo
echo "= RELOADING APACHE CONFIGURATION ="
vagrant ssh -c "sudo service apache2 reload" > /dev/null 2>&1
if [ $? -ne 0 ]
then
	error "Could not reload Apache's configuration automatically"
	error "You should reload it manually using the following command:"
	error "      sudo service apache2 reload"
else
	success "Apache successfully reloaded"
fi

echo
echo
success "END, thank you!"
success "You may now access the vhost:"
success "http://$hostname.vagrant.vm/"
echo
