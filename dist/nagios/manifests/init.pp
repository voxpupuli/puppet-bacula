# Class: nagios
#
# This class installs and configures Nagios
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios {
  include nagios::params

  package { $nagios::params::nagios_plugin_packages:
    ensure => installed,
  }

}
