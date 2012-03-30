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

  # Replaced, as the old plugin stopped working with.. ooh 2.6.x
  $plugins = [ 'puppet_agent_memory', 'puppet_runs' ]

  @munin::pluginconf { 'puppet_runs':
      confname => 'puppet_runs',
      confs => {
        'user'    => 'root',
        'command' => 'ruby %c',
      }
  }

  @munin::plugins::install{ puppet: }

  @munin::plugin{ $plugins: ,
    pluginpath => "${munin::params::plugin_source}/puppet",
    require    => Munin::Plugins::Install['puppet'],
  }
}
