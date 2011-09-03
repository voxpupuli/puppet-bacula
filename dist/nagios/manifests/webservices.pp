# Class: nagios::webservices
#
# This class installs and configures the Nagios web service checks
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::webservices {

  @@nagios_service { "check_http_${hostname}":
    use                 => 'generic-service',
    check_command       => 'check_http',
    host_name           => "$fqdn",
    hostgroup_name      => $location,
    service_description => "check_http_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_apache2_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    hostgroup_name      => $location,
    check_command       => 'check_nrpe!check_proc!1:50 apache2',
    service_description => "check_apache2_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

  define nagios::website {
    nagios_service { "$name":
      use                 => 'generic-service',
      check_command       => "check_http_site!$name",
      host_name           => "$fqdn",
      hostgroup_name      => $location,
      service_description => "$name",
      target              => '/etc/nagios3/conf.d/nagios_service.cfg',
      notify              => Service[$nagios::params::nagios_service],
    }
  }
} 
