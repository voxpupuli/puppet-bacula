# Class: munin::plugin
#
# This definitions installs and configures Munin plug-ins
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
define munin::plugin {
  include munin::params
  include munin

  file { "$munin::params::plugin_dest/$name":
    ensure => "$munin::params::plugin_source/$name",
    notify => Service['munin-node'],
  }

}
