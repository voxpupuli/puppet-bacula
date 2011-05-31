# Class: collectd::disable
#
# This class de-installs collectd
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
class collectd::disable {
  include collectd::params

  package { $collectd::params::collectd_packages:
    ensure  => absent,
    require => Service['collectd'],
  }

  service { 'collectd':
    ensure     => stopped,
    enable     => false,
    hasrestart => true,
  }

}

