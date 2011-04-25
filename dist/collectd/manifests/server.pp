# Class: collectd::server
#
# This class installs and configures the collectd server
#
# Parameters:
#
# Actions:
#
# Requires:
#   - collectd::params
#   - apache
#   - passenger
#   - rack
#
# Sample Usage:
#
# class { "collectd::params":
#   collectd_server => "collectd.example.com",
#   site_alias      => "visage.example.com",
# }
# include collectd::server
#
class collectd::server {
  include collectd::params
  include collectd
  include apache
  include ::passenger
  include passenger::params
  include ::rack

  $passenger_version = $passenger::params::version
  $gem_path          = $passenger::params::gem_path
  $collectd_server   = $collectd::params::collectd_server
  $site_alias        = $collectd::params::site_alias

  package { 
    [ 'librrd-dev', 'librrd-ruby' ]:
      ensure => present,
  }

  package { 
    [ 'sinatra' , 'haml', 'errand', 'yajl-ruby', 'tilt', 'visage-app' ]:
      provider => gem,
      ensure   => present,
      require  => Package['librrd-dev'],
  }

  file { 
    'collectd-server':
      path    => '/etc/collectd/collectd.conf',
      content => template('collectd/collectd-server.conf.erb'),
      ensure  => present,
      require => Package['collectd'],
  }

  apache::vhost { 
    "${site_alias}"
      port     => '80',
      priority => '55',
      docroot  => '/var/lib/gems/1.8/gems/visage-app-0.2.5/lib/visage/public',
      template => 'collectd/collectd-apache.conf.erb',
  }

  if defined(Class["firewall"]) { Firewall <<| dport == '25826' |>> }

}
