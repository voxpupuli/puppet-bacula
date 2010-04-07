# Class: nagios::server
#
# This class installs and configures the Nagios server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::server {
  include nagios
  include nagios::commands
  include nagios::contacts
  include nagios::params

  file { [ '/etc/nagios/conf.d/nagios_host.cfg', '/etc/nagios/conf.d/nagios_service.cfg', '/etc/nagios/conf.d/nagios_hostextinfo.cfg' ]:
    mode => 0644,
    ensure => present,
    before => Service[$nagios::params::nagios_service],
  }

  package { $nagios::params::nagios_packages:
    notify  => Service[$nagios::params::nagios_service],
  }
  
  service { $nagios::params::nagios_service:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    
  }

  Nagios_host <<||>>
  Nagios_hostextinfo <<||>>
  Nagios_service <<||>>
}

