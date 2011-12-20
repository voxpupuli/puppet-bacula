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

  # We assume for our modules, we have the motd module, & use it.
  motd::register{ "Munin server at ${site_alias}": }

  package { 'munin':
    ensure => present,
  }

  file { '/etc/munin/munin.conf':
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("munin/munin.conf.erb");
  }

  file { '/etc/apache2/conf.d/munin':
    ensure => absent,
  }

  apache::vhost { "$site_alias":
    port     => '443',
    priority => '40',
    ssl      => true,
    docroot  => '/var/cache/munin/www',
    template => 'munin/munin-apache.conf.erb',
    require  => [ Package['munin'], File['/etc/apache2/conf.d/munin'] ]
  }

  apache::vhost::redirect {
    "${site_alias}":
      port => 80,
      dest => "https://${site_alias}",
  }

  File <<| tag == 'munin_host' |>>

}

