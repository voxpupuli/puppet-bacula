# Class: munin::params
#
# This class contains the parameter for the Munin module
#
# Parameters:
#   site_alias: the alias of the munin apache vhost
# Actions:
#
# Requires:
#
# Sample Usage:
#
class munin::params (
  site_alias
) {

  $munin_server = '^74\.207\.240\.137$'
  $munin_server_clean = '74.207.240.137'
  $munin_base_packages = 'munin-node'
  $plugin_source = '/usr/share/munin/plugins'
  $plugin_dest = '/etc/munin/plugins'

}
