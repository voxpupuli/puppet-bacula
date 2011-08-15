Puppetlabs Modules
====

The is the repo that PuppetLabs uses to manage all infrastructure servers.

Modules
---

All of the following notes should be moved to module specific locations.

*Accounts
  - adds the sysadmin users
  - add sysadmin group (why does this require sudo?)
  - create users
    + add local group (not required)
    + manage home
  - add fragment to sshd_config for login
  - files
    + /home/title/.ssh
    + .ssh/authorized_keys2 – absent (dsa only?)
    + .ssh/authorized_keys – fill in details

* apache
  - packages
  - httpd
  - su-exec (why do we need this?), start service httpd
  - ssl packages
    + mod_ssl

* avahi (what does this do?)
  - service->disabled

* bind
  - client
    + packages
      # bind-libs (are these installed b default)
      # bind-utils (are these installed by default)
  - server
    + packages
      # bind
    + services
      # named service enable
    + files
      # snmp.conf (adds management line)
    + config secondary (stubbed out)

* bluez (bluetooth stuff)
  - packages (uninstall)
    + bluez-pin, libs, utils, hcidump

* cacti
  - packages
    + cacti (requires yum, php, mysql)
    + cacti-docs
    + cacti-spine
  - files
    + /etc/httpd/conf.d/cacti.conf
    + /var/www/cacti/include/config.php (template)
    + /etc/spine.conf (template)
  - mysql
    + create db
    + execute /var/www/cacti/cacti.sql
    + add user

* cron
  - packages
    + vixie-cron
    + crontabs
  - files
    + /etc/crontab
  - service
    + crond

* cups
  - service
    + cups (disable)

* dbus (what is using this message bus??, avahi depends on this??)
  - package
    + dbus
  - service
    + dbus

* git
  - includes
    + rsync
    + perl
  - packages
    + git
    + perl-git (requires perl, rsync

* hal (what the hal??, is it hardware abstraction layer?)
  - service 
    + hal disable

* iptables
  - package
    + iptables
  - file
    + /etc/sysconfig/iptables
    + /etc/sysconfig/iptables-config

* logrotate
  - package
    + logrotate
  - file
    + logrotate.conf
  - define - I had a definition that created logrotate entries

* motd
  - file
    + motd

* mysql
  - package 
    + mysql-server
    + MySQL-server-standard
    + MySQL-shared-compat
    + MySQL-client-standard
    + MySQL-devel-standard
    + perl-DBD-MySQL
    + mysql-devel
    + mysql-bench
    + MySQL-server-community
    + MySQL-devel-community 
    + MySQL-shared-community
    + perl-DBD-mysql
  - exec
    + remove mysql
  - service
    + mysqld
  - define
    + createdb
    + add user
    + execute scripts

* nagios
  - I will do this last, since it is complicated

* net-snmp 
  - also complicated, I will do later

* network-config
  - files
    + nsswitch.conf
    + resolve.conf
    + host.conf - what is this?
    + hosts

* nrpe
  - packages
    + nagios-nrpe
  - service 
    + nrpe
  - file
    + nrpe.local.cfg 
    + nrpe.conf

* openssh 
  - packages
    + openssh
    + openssh-server
  - service 
    sshd
  - file
    + sshd_config

* php
  - packages
    + php-common
    + php-cli
    + php-pdo
    + php

* postfix
  - package 
  - service
  - files
    + fetch_mail_statistics.pl (if net-snmp)
    + snmp.conf - add line

* ppp
  - package 
      + rp-pppoe
      + ppp

* prelink 
  - package 
      + ensure absent

* procps (change file and load changes)
  - files
    + sysctl.conf
  - exec sysctl -p
    + dd
  - package - procps

* puppet - do later
* rkhunter
* rsh
  - packages
    + rsh absent
    + rsh-server absent

* ruby
  - packages
    + ruby-gems
    + ruby-rdoc
    + ruby-irb

* selinux::absent
  - uninstall packages 

* sudo
  - file

* tmpwatch - 

* vim 
  - install vim-minimal, common, enhanced
Global definitions:

 

I need to have a look at this add line functionality it looks pretty sophisticated

 

 

ad

 

NOTES

 

iptables needs nrpe???

TODO:

Larry's sudoers is totally different.

tmpwatch is my friend

I dont care about rsh

I need to create an httpd reload that is notified when conf files change


-

everything needs to be self contained, we cannot use default params
 
It woudl make sense to be able to reset default params form outside the modules
