# Class: ntp
#
# This class installs and configures ntp
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The ntp::params class
#
# Sample Usage:
#
class ntp (
    $nagios = false,
    $server = '0.pool.ntp.org'
  ) {

  include ntp::params

  if $nagios == true {
    include ntp::nagios
  }

  package { 'ntp':
    ensure => present,
  }

  service { 'ntp':
    name       => "$ntp::params::ntpd_service",
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require => Package['ntp'],
  }

}

