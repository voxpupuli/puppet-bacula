# Class: ssh
#
# This class installs and manages SSH
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class ssh {
  include ssh::params

  $client_package = $ssh::params::client_package
  $ssh_config     = $ssh::params::ssh_config
  $sshd_config    = $ssh::params::sshd_config
  $ssh_service    = $ssh::params::ssh_service

  if $kernel == "Linux" {
    package { $client_package:
        ensure => latest,
    }
  }

  file { $ssh_config:
    owner     => root,
    group     => root,
    mode      => 0644,
    ensure    => file,
    require   => $kernel ? {
      "Darwin"  => undef,
      default => Package[$client_package]
    }
  }
}
