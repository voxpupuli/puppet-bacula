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
  include concat::setup
  $ssh_service = $ssh::params::ssh_service
  $sshclient_package = $ssh::params::sshclient_package

  package { 'openssh-server':
    ensure => latest, 
    require => Package["${sshclient_package}"],
    notify => Service['sshd'],
  }  
  concat::fragment { 'sshd_config-header':
    order => '00',
    target => '/etc/ssh/sshd_config',
    content => template("ssh/sshd_config.erb"),
  }
  concat { '/etc/ssh/sshd_config':
    mode => '0640',
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

  @firewall { 
    "0100-INPUT ACCEPT 22":
      jump  => 'ACCEPT',
      dport => "22",
      proto => 'tcp'
  }

}
