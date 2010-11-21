# Class: ssh::server
#
# This class installs and manages SSH servers
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class ssh::server {
  include ssh
	include ssh::params
	$ssh_service = $ssh::params::ssh_service
	$sshclient_package = $ssh::params::sshclient_package

  package { 'openssh-server':
    ensure => latest, 
    require => Package["${sshclient_package}"],
    notify => Service['sshd'],
  }  
  fragment { 'sshd_config-header':
    order => '00',
    path => '/etc/ssh',
    target => 'sshd_config',
    source => 'puppet:///modules/ssh/sshd_config',
  }
  fragment::concat { 'sshd_config':
    owner => 'root',
    group => 'root',
    mode => '0640',
    path => '/etc/ssh',
    require => Package['openssh-server'],
    notify => Service['sshd'],
  }
  service { 'sshd':
    name => "${ssh_service}",
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }
}
