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
class ntp {
  include ntp::params
  include ntp::nagios

  package { 'ntp':
    ensure => present,
  }

  service { 'ntp':
    ensure => running,
    enable     => true,
    hasrestart => true,
    require => Package['ntp'],
  }

}
