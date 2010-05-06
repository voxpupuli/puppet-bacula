# Class: munin::puppet
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
class munin::puppet {
  include munin::params
  include munin

  file { '/etc/munin/plugin-conf.d/puppet_runs':
    source => 'puppet:///modules/munin/puppet_runs',
    ensure => present,
  }

  file { '/usr/share/munin/plugins/puppet_runs':
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => 'puppet:///modules/munin/puppet_runs_plugin',
    ensure => present,
  }

  munin::plugin { 'puppet_runs':
    require => [ File['/usr/share/munin/plugins/puppet_runs'], File['/etc/munin/plugin-conf.d/puppet_runs'] ],
  }

  file { '/etc/munin/plugin-conf.d/puppet_memory':
    source => 'puppet:///modules/munin/puppet_memory',
    ensure => present,
  }

  file { '/usr/share/munin/plugins/puppet_memory':
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => 'puppet:///modules/munin/puppet_memory_plugin',
    ensure => present,
  }

  munin::plugin { 'puppet_memory':
    require => [ File['/usr/share/munin/plugins/puppet_memory'], File['/etc/munin/plugin-conf.d/puppet_memory'] ],
  }

}
