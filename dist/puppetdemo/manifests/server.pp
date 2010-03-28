# Class: puppetdemo::server
#
# This class installs and configures a Puppet master
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppet::server {
  include puppetdemo
  include puppetdemo::passenger

  package { $puppetdemo::params::puppetmaster_package:
    ensure => present,
  }
  file { '/etc/puppetdemo/namespaceauth.conf':
    owner => root,
    group => root,
    mode => 644,
    source => 'puppet:///modules/puppetdemo/namespaceauth.conf',
  }
  
  service {'puppetmaster': 
    ensure => stopped, 
    enable => false, 
    hasstatus => true,
    require => File['/etc/puppetdemo/puppet.conf'],
    before => Service['httpd'] 
  }
}
