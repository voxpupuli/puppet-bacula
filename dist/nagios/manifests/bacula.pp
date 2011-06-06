# Class: nagios::bacula
#
# This class installs and configures the Nagios hosts and services
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::bacula {

  @@nagios_service { "check_baculadir_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe!check_proc!1:1 bacula-dir',
    service_description => "check_baculadir_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_baculasd_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe!check_proc!1:1 bacula-sd',
    service_description => "check_baculasd_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_baculafd_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe!check_proc!1:1 bacula-fd',
    service_description => "check_baculafd_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_baculadisk_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe_1arg!check_xvdc',
    service_description => "check_bacula_disk_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }


}
