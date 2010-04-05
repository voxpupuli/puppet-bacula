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

  file { "/usr/lib/nagios/plugins/check_bacula.pl":
    source => "puppet:///modules/nagios/check_bacula.pl",
    mode => 0755,
    ensure => present,
  }

  package { $nagios::params::nagios_plugin_packages:
    ensure => installed,
  }

}
