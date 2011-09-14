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
    $site_alias = $fqdn,
    $external_commands = false,
    $external_users = 'nagiosadmin',
    $brokers = undef
  ) {

  include apache
  include nagios
  include nagios::commands
  include nagios::contacts
  include nagios::params
  include nagios::hostgroups
  include virtual::nagioscontacts

  # Do we want external commands?
  # http://nagios.sourceforge.net/docs/3_0/extcommands.html
  if $external_commands == true {
    $nagiosexternal = 1

    # On debian, we need to make sure that
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=571801 is
    # followed in nagios3 to enable external commands.
    $nagioscommandfile = '/var/lib/nagios3/rw/nagios.cmd'
    $nagioscommanddir  = '/var/lib/nagios3/rw/'

    # now we can do it the debian way, urg, and do it the puppet way
    # as well. Just so long as they match.

    if $operatingsystem == 'debian' {
      exec{ 'fix_nagios3_external_commands_perms_hack':
        command => '/etc/init.d/nagios3 stop && dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw && dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3 && /etc/init.d/nagios3 start',
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        creates => $nagioscommandfile,
        before  => File[$nagioscommanddir],
      }
    }

    # now do it the puppet way too.
    file{ $nagioscommanddir:
      owner  => 'nagios',
      group  => 'www-data',
      mode   => '2710',
      ensure => directory,
    }

  } else {
    $nagiosexternal = 0
  }


  # do we have brokers defined? If we do, are they an array? Lets hope
  # so, as that's what the template is after.
  if $brokers != undef {
    # If we're here, we need to set broker options and the right broker
    # lines.

    $nagios_event_broker_options = '-1'
    $nagiosbrokers = $brokers
  } else {
    $nagios_event_broker_options = '0'
  }


  file { '/etc/nagios/nagios.cfg':
    mode    => 0644,
    ensure  => present,
    content => template( 'nagios/nagios.cfg.erb' ),
    before  => Service[$nagios::params::nagios_service],
  }

  file { '/etc/nagios3/cgi.cfg':
    mode    => 0644,
    ensure  => present,
    content => template( 'nagios/cgi.cfg.erb' ),
    before  => Service[$nagios::params::nagios_service],
  }


  file { [ '/etc/nagios/conf.d/nagios_host.cfg', '/etc/nagios/conf.d/nagios_service.cfg'  ]:
    mode   => 0644,
    ensure => present,
    before => Service[$nagios::params::nagios_service],
  }

  file { [ '/etc/nagios/apache2.conf', '/etc/apache2/conf.d/nagios3.conf' ]:
    ensure => absent,
  }

  file { "/usr/share/nagios3/htdocs/stylesheets":
    ensure => link,
    target => "/etc/nagios3/stylesheets",
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

#  apache::vhost::redirect {
#    "$site_alias":
#      port => 80,
#      dest => "https://${site_alias}",
#  }

  apache::vhost { "${site_alias}":
    port          => '80',
    serveraliases => "$site_alias",
    priority      => '30',
    ssl           => false,
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

