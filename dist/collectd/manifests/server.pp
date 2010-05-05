# Class: collectd::server
#
# This class installs and configures the collectd server
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The collectd::params class
#
# Sample Usage:
#
class collectd::server {
  include collectd::params
  include collectd
  include apache
  require vcsrepo

  $collectd_server = $collectd::params::collectd_server

  package { [ 'librrd-dev', 'librrd-ruby' ]:
    ensure => present,
  }

  package { [ 'sinatra' , 'haml', 'errand', 'yajl-ruby' ]:
    provider => gem,
    ensure => present,
    require => Package['librrd-dev'],
  }

  file { 'collectd-server':
    path => '/etc/collectd/collectd.conf',
    content => template('collectd/collectd-server.conf.erb'),
    ensure => present,
    require => Package['collectd'],
  }

  apache::vhost { 'visage.puppetlabs.com':
    port => '80',
    priority => '55',
    docroot => '/var/www/visage/public',
    template => 'collectd/collectd-apache.conf.erb',
  }

  vcsrepo { '/var/www/visage':
    source => 'http://github.com/auxesis/visage.git',
    provider => git,
    ensure => present,
  }

}
