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
  include nagios::command

  include apache::ssl 
  include mailx
  
  File{
    checksum   => md5,
    ensure     => present,
    replace    => true,
    owner      => 'root',
    group      => 'nagios',
    mode       => '0440',
    require    => Package[$nagios::params::nagios_packages],
    notify     => Service["nagios"],
  }
  file{  [ "/etc/nagios/nagios_command.cfg",
           "/etc/nagios/nagios_contact.cfg",
           "/etc/nagios/nagios_contactgroup.cfg",
           "/etc/nagios/nagios_host.cfg",
           "/etc/nagios/nagios_hostextinfo.cfg",
           "/etc/nagios/nagios_hostgroup.cfg",
           "/etc/nagios/nagios_hostgroupescalation.cfg",
           "/etc/nagios/nagios_service.cfg",
           "/etc/nagios/nagios_servicedependency.cfg",
           "/etc/nagios/nagios_serviceescalation.cfg",
           "/etc/nagios/nagios_serviceextinfo.cfg",
           "/etc/nagios/nagios_timeperdiod.cfg" ]:
        ensure => file,
        replace => false,
        notify => Service[nagios],
  }
  # make sure resource.cfg has proper perms
  file { "/etc/nagios/private/resource.cfg":
    mode       => '0640',
  }
  package { $nagios::params::nagios_packages:
    notify  => Service["nagios"],
    require => [ Class["apache::ssl"], Class["mailx"] ],
  }
  
  file { "/etc/nagios/htpasswd.users":
    mode       => '0640',
  }
  
  service { "nagios":
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }
}
