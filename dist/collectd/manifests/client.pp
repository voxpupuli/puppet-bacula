# Class: collectd::client
#
# This class configures the collectd client
#
# Parameters:
#
# Actions:
#
# Requires:
#   - collectd::params
#
# Sample Usage:

# class { "collectd::params":
#   collectd_server => "collectd.example.com",
#   site_alias      => "visage.example.com",
# }
# include collectd::client
#
class collectd::client {
  include collectd::params
  include collectd

  $collectd_server = $collectd::params::collectd_server

  file { 'collectd-client':
    path => $collectd::params::collectd_configuration,
    content => template('collectd/collectd-client.conf.erb'),
    ensure => present,
    require => Package['collectd'],
  }

  @@firewall { "0160-INPUT allow 25826 udp $ipaddress":
    proto  => 'udp',
    dport  => '25826',
    source => "$ipaddress",
    jump   => 'ACCEPT',
  }

}
