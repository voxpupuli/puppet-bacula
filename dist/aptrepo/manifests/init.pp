# Class: aptrepo
#
# This class installs and configures a local APT repo
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class aptrepo {
  include apache

  package { 'reprepro':
    ensure => present,
  }

  file { '/opt/repository/apt':
    ensure => directory,
  }

  file { [ '/opt/repository/apt/ubuntu', '/opt/repository/apt/ubuntu/conf', '/opt/repository/apt/ubuntu/override' ]:
    ensure => directory,
    require => File['/opt/repository/apt'],
  }

  file { '/opt/repository/apt/ubuntu/conf/distributions':
    ensure => present,
    source => 'puppet:///modules/aptrepo/distributions',
    require => File['/opt/repository/apt/ubuntu/conf'],
  }

  file { '/opt/repository/apt/ubuntu/conf/options':
    ensure => present,
    source => 'puppet:///modules/aptrepo/options',
    require => File['/opt/repository/apt/ubuntu/conf'],
  }

  file { '/opt/repository/apt/ubuntu/override/override.lucid':
    ensure => present,
    source => 'puppet:///modules/aptrepo/override.lucid',
    require => File['/opt/repository/apt/ubuntu/override'],
  }

  apache::vhost { 'apt.puppetlabs.com': 
    priority => '10',
    port => '80',
    docroot => '/opt/repository/apt',
    template => 'aptrepo/apache2.conf.erb'
  }

}

