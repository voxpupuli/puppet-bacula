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
	$sshclient_package = $ssh::params::sshclient_package
  package { "${sshclient_package}":
    ensure => latest,
  }

  file { '/etc/ssh/ssh_config':
    owner   => root,
    group   => root,
    mode    => 0644,
    ensure  => file,
    require => Package["${sshclient_package}"]
  }
}
