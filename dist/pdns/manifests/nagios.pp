# Class: pdns::nagios
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
class pdns::nagios {

  @@nagios_service { "check_pdns_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_nrpe!check_proc!1:5 pdns_server',
    service_description => "check_pdns_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

}
