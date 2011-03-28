# Class: jenkins
#
# This class installs and configures jenkins
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The jenkins::params class
#
# Sample Usage:
#
class jenkins {
  include jenkins::params
  include apache
  include git

  $jenkins_alias = $jenkins::params::jenkins_alias

	package { $jenkins::params::jetty_packages: 
		ensure => installed,
	}

	package { $jenkins::params::build_packages_gems:
		ensure => installed,
		provider => gem,
	}
  # war retrieved from http://mirrors.jenkins-ci.org/war/latest/
  file { 'jenkins.war':
    path => '/usr/share/jetty/webapps/root.war',
    source => 'puppet:///modules/jenkins/jenkins.war',
    owner => 'jetty',
    group => 'adm',
    require => Package[$jenkins::params::jetty_packages],
    notify => Service['jetty'],
  }

  file { '/etc/default/jetty':
    source => 'puppet:///modules/jenkins/jetty.default',
  }

  service { 'jetty':
    ensure => running,
    enable => true, 
    hasstatus => true,
    require => [ File['/etc/default/jetty'], Package[$jenkins::params::jetty_packages] ],
  }

  a2mod { [ 'proxy', 'proxy_http', 'proxy_balancer', 'proxy_ajp' ]: ensure => present, }

  apache::vhost { 'ci.puppetlabs.com':
    port => '80',
    priority => '10',
    docroot => 'null',
    template => 'jenkins/jenkins-apache.conf.erb',
    require => [ Service['jetty'], A2mod['proxy'] ]
  }

}
