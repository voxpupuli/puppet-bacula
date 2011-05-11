# Class: munin::passenger
#
# This class installs and configures Munin for Passengers
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
class munin::passenger {
  include munin::params
  include munin

  file { '/etc/munin/plugin-conf.d/passenger':
    source => 'puppet:///modules/munin/passenger',
    ensure => present,
  }

  file { '/usr/share/munin/plugins/passenger_status':
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => 'puppet:///modules/munin/passenger_status',
    ensure => present,
  }

  file { '/usr/share/munin/plugins/passenger_memory_status':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/munin/passenger_memory_status',
    ensure => present,
  }

  munin::plugin { [ 'passenger_status', 'passenger_memory_status' ]:
    require => [ File['/usr/share/munin/plugins/passenger_status'], File['/usr/share/munin/plugins/passenger_memory_status'], File['/etc/munin/plugin-conf.d/passenger'] ],
  }

  if defined(Class['sudo']) { 
    sudo::entry { "munin-sudo":
      entry => "munin ALL=(ALL) NOPASSWD:/usr/bin/passenger-status, /usr/bin/passenger-memory-stats";
    }
  }

}
