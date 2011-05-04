# Class: munin::server
#
# This class installs and configures the Munin server
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The munin::params class
#
# Sample Usage:
#
class munin::server (
    $site_alias = $fqdn
  ) {
  include apache
  include munin::params

  package { 'munin':
    ensure => present,
  }

  file { '/etc/apache2/conf.d/munin':
    ensure => absent,
  }

  apache::vhost { "$site_alias":
    port => '80',
    priority => '40',
    docroot => '/var/cache/munin/www',
    template => 'munin/munin-apache.conf.erb',
    require => [ Package['munin'], File['/etc/apache2/conf.d/munin'] ]
  }

  File <<| tag == 'munin_host' |>>
  
}
