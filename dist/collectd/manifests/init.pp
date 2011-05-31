# Class: collectd
#
# This class installs and configures collectd
#
# Parameters:
#
# Actions:
#
# Requires:
#   - The collectd::params class
#
# Sample Usage:
#
class collectd {
  include collectd::params

  package { $collectd::params::collectd_packages:
    ensure => present,
  }

  service { 'collectd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['collectd'],
  }

}
