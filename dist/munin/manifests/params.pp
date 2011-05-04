# Class: munin::params
#
# This class contains the parameter for the Munin module
#
# Parameters:
#   site_alias: the alias of the munin apache vhost
#   munin_server: the IP address of the munin server
# Actions:
#
# Requires:
#
# Sample Usage:
#
class munin::params (
  site_alias,
  munin_server
) {

  $munin_base_packages = 'munin-node'
  $plugin_source = '/usr/share/munin/plugins'
  $plugin_dest = '/etc/munin/plugins'

}
