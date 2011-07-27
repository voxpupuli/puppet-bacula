#! /bin/bash

cat > /etc/yum.repos.d/ruby.repo <<END
[ruby]
name=ruby
baseurl=http://repo.premiumhelp.eu/ruby/
gpgcheck=1
enabled=0
END

cat > /etc/yum.repos.d/epel-puppet.repo <<END
[epel-puppet]
name=epel puppet
baseurl=http://tmz.fedorapeople.org/repo/puppet/epel/5/\$basearch/
enabled=1
gpgcheck=0
END

yum install -y puppet

