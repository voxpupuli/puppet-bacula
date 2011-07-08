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
  $sshd_config = $ssh::params::sshd_config

  if $kernel == "Linux" {
    package { 'openssh-server':
      ensure  => latest, 
      require => Package["${sshclient_package}"],
      notify  => Service['sshd'],
    }
  }

  concat::fragment { 'sshd_config-header':
    order   => '00',
    target  => "$sshd_config",
    content => template("ssh/sshd_config.erb"),
  }
  concat { "$sshd_config":
    mode    => '0640',
    require => Package['openssh-server'],
    notify  => Service['sshd'],
  }
  service { 'sshd':
    name       => "$ssh_service",
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

#  @firewall {
#    "0100-INPUT ACCEPT 22":
#      jump  => 'ACCEPT',
#      dport => "22",
#      proto => 'tcp'
#  }

}
