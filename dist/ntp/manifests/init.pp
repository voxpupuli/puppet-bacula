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
    $server = ['0.pool.ntp.org','1.pool.ntp.org']
  ) {

  include ntp::params
  $template      = $::ntp::params::template
  $ntpd_service  = $::ntp::params::ntpd_service
  $ntpserver     = $server

  file { "/etc/ntp.conf":
    owner   => root,
    group   => 0,
    mode    => 640,
    content => template("$template"),
    notify  => Service['ntp'],
  }

  if $nagios == true {
    include ntp::nagios
  }

  if $kernel == "Linux" {
    package { 'ntp':
      ensure => present,
    }
  }
  service { 'ntp':
    name       => "$ntpd_service",
    ensure     => running,
    enable     => true,
    hasrestart => $kernel ? {
      linux => true,
      default => undef 
    },
    require => $kernel ? {
      linux => Package['ntp'],
      default => undef,
    }
  }

}

