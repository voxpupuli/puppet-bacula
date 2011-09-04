# Class: ntp::nagios
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
class ntp::nagios {

  @@nagios_service { "check_ntpd_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_nrpe!check_proc!1:1 ntpd',
    service_description => "check_ntpd_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

}
