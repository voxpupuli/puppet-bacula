# Class: puppetdemo::passenger
#
# This class installs and configures Passenger for Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class puppetdemo::passenger {
  include ruby::dev
  include apache::ssl
  include ::passenger
  include passenger::params
  include ::rack

  $passenger_version=$passenger::params::version
  $gem_path=$passenger::params::gem_path
  
  file { ['/etc/puppetdemo/rack', '/etc/puppetdemo/rack/public', '/etc/puppetdemo/rack/tmp']:
    owner => 'puppet',
    group => 'puppet',
    ensure => directory,
  }
  file { '/etc/puppetdemo/rack/config.ru':
    owner => 'puppet',
    group => 'puppet',
    mode => 0644,
    source => 'puppet:///modules/puppetdemo/config.ru',
  }

  apache::vhost{ 'demo-puppetmaster':
    port => '8140',
    priority => '10',
    docroot => '/etc/puppetdemo/rack/public/',
    ssl => true,
    template => 'puppetdemo/puppet-passenger.conf.erb',
  }
}
