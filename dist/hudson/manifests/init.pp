# Class: hudson
#
# This class installs and configures hudson
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The hudson::params class
#
# Sample Usage:
#
class hudson {
  include hudson::params
  include apache
  include git

  $hudson_alias = $hudson::params::hudson_alias

	package { $hudson::params::jetty_packages: 
		ensure => installed,
	}

	package { $hudson::params::build_packages_gems:
		ensure => installed,
		provider => gem,
	}

  file { 'hudson.war':
    path => '/usr/share/jetty/webapps/root.war',
    source => 'puppet:///modules/hudson/hudson.war',
    owner => 'jetty',
    group => 'adm',
    require => Package[$hudson::params::jetty_packages],
    notify => Service['jetty'],
  }

  file { '/etc/default/jetty':
    source => 'puppet:///modules/hudson/jetty.default',
  }

  service { 'jetty':
    ensure => running,
    enable => true, 
    hasstatus => true,
    require => [ File['/etc/default/jetty'], Package[$hudson::params::jetty_packages] ],
  }

  a2mod { [ 'proxy', 'proxy_http', 'proxy_balancer', 'proxy_ajp' ]: ensure => present, }

  apache::vhost { 'ci.puppetlabs.com':
    port => '80',
    priority => '10',
    docroot => 'null',
    template => 'hudson/hudson-apache.conf.erb',
    require => [ Service['jetty'], A2mod['proxy'] ]
  }

}
