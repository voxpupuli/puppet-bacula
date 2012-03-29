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


  # Replaced, as the old plugin stopped working with.. ooh 2.6.x
  $plugins = [ 'puppet_agent_memory']

  munin::plugins::install{ puppet: }

  munin::plugin{ $plugins: ,
    pluginpath => "${munin::params::plugin_source}/puppet",
    require    => Munin::Plugins::Install['puppet'],
  }
}
