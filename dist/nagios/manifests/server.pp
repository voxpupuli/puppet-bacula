# Class: nagios::server
#
# This class installs and configures the Nagios server
#
# Parameters:
# * $site_alias
#   DNS Alias for the website
#
# Actions:
#
# Requires:
#   apache
#   nagios::params
#
# Sample Usage:
#
class nagios::server (
    $site_alias = $fqdn
  ) {

  include apache
  include nagios
  include nagios::commands
  include nagios::contacts
  include nagios::params

  file { [ '/etc/nagios/conf.d/nagios_host.cfg', '/etc/nagios/conf.d/nagios_service.cfg'  ]:
    mode   => 0644,
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

  apache::redirect {
    "$site_alias":
      port => 80,
      dest => "https://${site_alias}",
  }

  apache::vhost { "${site_alias}_ssl":
    port          => '443',
    serveraliases => "$site_alias",
    priority      => '30',
    #ssl          => 'false',
    docroot       => '/usr/share/nagios3/htdocs',
    template      => 'nagios/nagios-apache.conf.erb',
    require       => [ File['/etc/nagios/apache2.conf'], Package[$nagios::params::nagios_packages] ], 
  }

  #apache::vhost { 'nagios.puppetlabs.com_ssl':
  #  port => '443',
  #  priority => '31',
  #	ssl      => 'true',
  #  docroot => '/usr/share/nagios3/htdocs',
  #  template => 'nagios/nagios-apache.conf.erb',
  #  require => [ File['/etc/nagios/apache2.conf'], Package[$nagios::params::nagios_packages] ], 
  #}

  Nagios_host <<||>>
  Nagios_service <<||>>
}

