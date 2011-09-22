# Class: munin::params
#
# This class contains the parameter for the Munin module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class munin::params {

  case $operatingsystem {
    "darwin": {
      $munin_base_packages = 'munin'
      $plugin_source = '/opt/local/usr/share/munin/plugins'
      $plugin_dest   = '/opt/local/etc/munin/plugins'
      $log_file      = '/opt/local/var/log/munin/munin-node.log'
      $pid_file      = '/opt/local/var/run/munin/munin-node.pid'
      $node_service  = 'org.macports.munin-node.plist'
      $node_config   = '/opt/local/etc/munin/munin-node.conf'
    }
    default: {
      $munin_base_packages = 'munin-node'
      $plugin_source       = '/usr/share/munin/plugins'
      $plugin_dest         = '/etc/munin/plugins'
      $node_service        = 'munin-node'
      $node_config         = '/etc/munin/munin-node.conf'
    }
  }
}
