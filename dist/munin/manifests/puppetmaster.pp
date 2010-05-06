# Class: munin::puppetmaster
#
# This class installs and configures Munin for Puppet masters
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
class munin::puppetmaster {
  include munin::params
  include munin

  file { '/etc/munin/plugin-conf.d/puppet_clients':
    source => 'puppet:///modules/munin/puppet_clients',
    ensure => present,
  }

  file { '/usr/share/munin/plugins/puppet_clients':
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => 'puppet:///modules/munin/puppet_clients_plugin',
    ensure => present,
  }

  munin::plugin { 'puppet_clients':
    require => [ File['/usr/share/munin/plugins/puppet_clients'], File['/etc/munin/plugin-conf.d/puppet_clients'] ],
  }

}

