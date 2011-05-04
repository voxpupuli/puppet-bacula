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

  $munin_base_packages = 'munin-node'
  $plugin_source = '/usr/share/munin/plugins'
  $plugin_dest = '/etc/munin/plugins'

}
