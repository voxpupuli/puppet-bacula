# Class: jenkins
#
# This class installs and configures the Jenkins CI system.
#
# Parameters:
# - site_alias - The hostname that the site will be reachable by
# - backup - weather to schedule a backup job for jenkins
#
# Actions:
#
# Requires:
# - The jenkins::params class
#
# Sample Usage:
# include jenkins
#
# TODO: Move apt-key import into defined type
# Apt repo creattion should be a defined type
# Apt-get update should be triggered
# Apache modules should be moved to apache class and realized when needed
# Test for distro, currently only apt based 
class jenkins (
  $site_alias,
  $backup = true
  ) {
  include jenkins::params
  include git

  if $backup == true {
    include jenkins::backup
  }

  nagios::website { "$site_alias": }

  exec { "Import jenkins apt-key":
    path        => "/bin:/usr/bin",
    environment => "HOME=/root",
    command     => "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -",
    user        => "root",
    unless      => "apt-key list | grep D50582E6",
    logoutput   => on_failure,
  }

  file { "/etc/apt/sources.list.d/jenkins-ci.list": content => "deb http://pkg.jenkins-ci.org/debian binary/"; } 

  package { "jenkins": ensure => installed, require => File["/etc/apt/sources.list.d/jenkins-ci.list"]; }

  a2mod { [ 'proxy', 'proxy_http', 'proxy_balancer', 'proxy_ajp' ]: ensure => present, }

  apache::vhost::redirect {
    "${site_alias}":
      port => '80',
      dest => "https://${site_alias}",
  }

  apache::vhost::proxy {
    "${site_alias}_ssl":
      serveraliases => "${site_alias}",
      port          => '443',
      ssl           => true,
      dest          => 'http://localhost:8080',
  }

  service { "jenkins":
    ensure => running,
    enable => true,
    require => Package["jenkins"],
  }
}
