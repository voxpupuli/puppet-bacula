# Class: munin
#
# This class installs and configures Munin
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
class munin {
  include munin::params

  $munin_server = $munin::params::munin_server
  $munin_server_clean = $munin::params::munin_server_clean

  package { 
    $munin::params::munin_base_packages:
      ensure => present,
  }

  file { 
    '/etc/munin/munin-node.conf':
      content => template('munin/munin-node.conf.erb'),
      ensure  => present,
      notify  => Service['munin-node'],
  }

  service { 'munin-node':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => [ File['/etc/munin/munin-node.conf'], Package['munin-node'] ],
  }

  @@file { "/etc/munin/munin-conf.d/$fqdn":
    content => template('munin/munin-host.conf.erb'),
    ensure  => present,
    tag     => 'munin_host',
  }

  @firewall { 
    '0150-INPUT ACCEPT 4949':
      jump   => 'ACCEPT',
      dport  => "4949",
      proto  => 'tcp',
      source => "$munin_server_clean",
  }

}
