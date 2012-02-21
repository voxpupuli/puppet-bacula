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
      $confdir             = '/opt/local/etc/munin'
      $munin_base_packages = 'munin'
      $plugin_source       = '/opt/local/usr/share/munin/plugins'
      $plugin_dest         = '/opt/local/etc/munin/plugins'
      $group               = 'wheel'
      $log_file            = '/opt/local/var/log/munin/munin-node.log'
      $pid_file            = '/opt/local/var/run/munin/munin-node.pid'
      $node_service        = 'org.macports.munin-node'
      $node_config         = '/opt/local/etc/munin/munin-node.conf'
    }
    'freebsd': {
      $confdir              = '/usr/local/etc/munin'
      $munin_base_packages  = 'sysutils/munin-node'
      $plugin_source        = '/usr/local/share/munin/plugins'
      $plugin_dest          = '/usr/local/etc/munin/plugins'
      $group                = 'wheel'
      $log_file             = '/var/log/munin/munin-node.log'
      $pid_file             = '/var/run/munin/munin-node.pid'
      $node_service         = 'munin-node'
      $node_config          = '/usr/local/etc/munin/munin-node.conf'
    }
    default: {
      $confdir             = '/etc/munin'
      $log_file            = '/var/log/munin/munin-node.log'
      $pid_file            = '/var/run/munin/munin-node.pid'
      $group               = 'root'
      $munin_base_packages = 'munin-node'
      $plugin_source       = '/usr/share/munin/plugins'
      $plugin_dest         = '/etc/munin/plugins'
      $node_service        = 'munin-node'
      $node_config         = '/etc/munin/munin-node.conf'
    }
  }
}
