# VAGRANT LAMP ENVIRONMENT

## Objectifs

Ce dépôt vous permet de récupérer une version fonctionnelle de LAMP sous Ubuntu 16.04 LTS pour Vagrant pour vos développements locaux. 

En une ligne de commande, un environnement LAMP est installé sur le poste du développeur, avec tous les outils nécessaires.

Tous les développeurs partagent donc de façon aisée les mêmes outils et les mêmes versions. Si certains outils sont manquants ou certaines configurations sont à adapter. Il suffit ensuite de relancer un `vagrant provision` pour récupérer les mises à jour. 

### ⚠ Attention ⚠
Le principe général est le suivant : la VM Ubuntu ne doit pas être modifiée localement car les modifications seront écrasées à la prochaine mise à jour. Il ne faut donc pas **installer quoi que ce soit sur la VM directement, ni conserver des fichiers sur la VM**, tout cela pourrait être définitivement perdu. Les fichiers ou dossiers doivent être stockés sur la machine Host et partagés sur la machine Guest (VM).

Ceci étant dit, vous pouvez faire ce que vous voulez de votre VM : installer, désinstaller, détruire, réparer, corrompre... car vous savez qu'il suffit de `vagrant destroy` et de `vagrant up` de nouveau pour retrouver une VM fraiche, avec tous les outils réinstallés. 

## Contenu

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

- Télécharger et installer VirtualBox (http://www.virtualbox.org/)
- Télécharger et installer Vagrant (https://www.vagrantup.com/)
- Cloner la dernière version du dépôt (https://github.com/axeloz/vagrant-lamp) dans `/Users/utilisateur/Sites`
- Ouvrir un Terminal et se rendre dans le dossier ainsi téléchargé
- Lancer une commande `vagrant up`
- Optionnellement, vous pouvez installer Vagrant Manager (http://vagrantmanager.com/) pour gérer la Virtual Machine

### ⚠ Attention ⚠
Le montage du dossier /vagrant se fait à présent en NFS. Cette opération nécessite les droits administrateurs de votre machine hôte. Il vous sera demandé votre passe de passe de session à chaque démarrage de la machine. Pour éviter cela, il est possible d'éditer les sudoers pour autoriser Vagrant à opérer les changements NFS en ajoutant, dans la configuration des sudoers, les lignes suivantes :

```
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE
```

## Mise à jour

- Se rendre à la racine du dépôt `/Users/utilisateur/Sites/vagrant-lamp`
- Faire un `git pull`
- Faire un `vagrant reload --provision`

## Accès

- Pour accéder en SSH à la VM, lancez `vagrant ssh` depuis le dossier de la VM
- Une IP `192.168.99.100` est créée par la VM
- La VM répond également sur `localhost`
- Pour accéder aux sites : http://localhost:8080
- Pour accéder à l'interface de Mailcatcher : http://localhost:1080
- Pour accéder à MySQL depuis le Host : mysql://vagrant:vagrant@localhost:3306
- Pour accéder au SMTP de Mailcatcher depuis le Host : smtp://localhost:1025
- Pour accéder à BrowserSync depuis le Host : http://localhost:3000
- Pour accéder à DRUSH, lancez la commande `drush` depuis la VM
- Pour accéder à WP_CLI, lancez la commande `wp` depuis la VM
- Pour accéder à DEPLOYER, lancez la commande `dep` depuis la VM
- Pour accéder à GULP, lancez la commande `gulp` depuis la VM

## Fonctionnalités à ajouter 

- Postfix


