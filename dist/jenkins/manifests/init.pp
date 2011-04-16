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
# TODO: Move apt-key import into defined type
# Apt repo creattion should be a defined type
# Apt-get update should be triggered
# Apache modules should be moved to apache class and realized when needed
# Test for distro, currently only apt based 


class jenkins ($alias) {
  include jenkins::params
  #include apache
  include git

  exec { "Import jenkins apt-key":
    path        => "/bin:/usr/bin",
    environment => "HOME=/root",
    command     => "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -",
    user        => "root",
    unless      => "apt-key list | grep D50582E6",
    logoutput   => on_failure,
  }

  file { "/etc/apt/sources.list.d/jenkins-ci.list": content => "deb http://pkg.jenkins-ci.org/debian binary/"; } 

  package { "jenkins": ensure => instaled, require => File["/etc/apt/sources.list.d/jenkins-ci.list"]; }

#  package { $jenkins::params::jetty_packages: 
#    ensure => installed,
#  }
#
#  package { $jenkins::params::build_packages_gems:
#    ensure => installed,
#    provider => gem,
#  }
#
#  # war retrieved from http://mirrors.jenkins-ci.org/war/latest/
#  file { 'jenkins.war':
#    path => '/usr/share/jetty/webapps/root.war',
#    source => 'puppet:///modules/jenkins/jenkins.war',
#    owner => 'jetty',
#    group => 'adm',
#    require => Package[$jenkins::params::jetty_packages],
#    notify => Service['jetty'],
#  }
#
#  file { '/etc/default/jetty':
#    source => 'puppet:///modules/jenkins/jetty.default',
#  }
#
#  service { 'jetty':
#    ensure => running,
#    enable => true, 
#    hasstatus => true,
#    require => [ File['/etc/default/jetty'], Package[$jenkins::params::jetty_packages] ],
#  }
#
  a2mod { [ 'proxy', 'proxy_http', 'proxy_balancer', 'proxy_ajp' ]: ensure => present, }
#
#  apache::vhost { 'ci.puppetlabs.com':
#    port => '80',
#    priority => '10',
#    docroot => 'null',
#    template => 'jenkins/jenkins-apache.conf.erb',
#    require => [ Service['jetty'], A2mod['proxy'] ]
#  }

  apache::vhost::redirect {
    "${alias}":
      port => '80',
      dest => "https://${alias}",
  }

  apache::vhost::proxy {
    "${alias}_ssl":
      serveraliases => "${alias}",
      port          => '443',
      dest          => 'http://localhost:8080',
  }


}
