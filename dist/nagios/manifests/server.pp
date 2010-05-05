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
  include apache
  include nagios
  include nagios::commands
  include nagios::contacts
  include nagios::params

  file { [ '/etc/nagios/conf.d/nagios_host.cfg', '/etc/nagios/conf.d/nagios_service.cfg'  ]:
    mode => 0644,
    ensure => present,
    before => Service[$nagios::params::nagios_service],
  }

  file { [ '/etc/nagios/apache2.conf', '/etc/apache2/conf.d/nagios3.conf' ]:
    ensure => absent,
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

  apache::vhost { 'nagios.puppetlabs.com':
    port => '80',
    priority => '30',
    docroot => '/usr/share/nagios3/htdocs',
    template => 'nagios/nagios-apache.conf.erb',
    require => [ File['/etc/nagios/apache2.conf'], Package[$nagios::params::nagios_packages] ], 
  }

  Nagios_host <<||>>
  Nagios_service <<||>>
}

