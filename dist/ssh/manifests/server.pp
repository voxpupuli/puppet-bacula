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
  $ssh_service    = $ssh::params::ssh_service
  $server_package = $ssh::params::server_package
  $sshd_config    = $ssh::params::sshd_config

  if $kernel == "Linux" {
    if !defined(Package[$server_package]) {
      package { $server_package:
        ensure  => latest, 
        notify  => Service['sshd'],
      }
    }
  }

  concat::fragment { 'sshd_config-header':
    order   => '00',
    target  => $sshd_config,
    content => template("ssh/sshd_config.erb"),
  }
  concat { $sshd_config:
    mode    => '0640',
    require => $kernel ? {
      "Darwin" => undef,
      'freebsd' => undef,
      default  => Package[$server_package],
    },
    notify  => Service['sshd'],
  }
  service { 'sshd':
    name       => $ssh_service,
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}

