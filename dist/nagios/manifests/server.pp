# Class: nagios::server
#
# This class installs and configures the Nagios server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::server {
  include nagios
  include nagios::params
  include apache::ssl 
  include mailx
  
  File{
    checksum   => md5,
    ensure     => present,
    replace    => true,
    owner      => 'root',
    group      => 'nagios',
    mode       => '0440',
    require    => Package["nagios"],
    notify     => Service["nagios"],
  }
  # install commands.cfg
  file { "/etc/nagios/commands.cfg":
    source => "puppet:///nagios/commands.cfg",
  }
	# install event_handlers.cfg
  file { "/etc/nagios/event_handlers.cfg":
    source => "puppet:///nagios/event_handlers.cfg",
  }
  # install timeperiods.cfg
  file { "/etc/nagios/timeperiods.cfg":
    source     => "puppet:///nagios/timeperiods.cfg",
  }
  # make sure resource.cfg has proper perms
  file { "/etc/nagios/private/resource.cfg":
		mode       => '0640',
  }
  package { "nagios":
    notify  => Service["nagios"],
    require => [ Class["apache::ssl"], Class["mailx"] ],
  }
  # allow for NRPE communciation
  package { "nagios-plugins-nrpe":
    require    => [ Package["nagios"], Package["nagios-plugins"] ],
  }
	# make sure our nagios.conf is installed 
  file { "/etc/httpd/conf.d/nagios.conf":
    source => "puppet:///nagios/nagios.conf",
    group  => 'root',
    notify => undef,
  }
	# monitor htpasswd.users
  file { "/etc/nagios/htpasswd.users":
    mode       => '0640',
  }
  # make sure nagios is setup to run
  service { "nagios":
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }
}
