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
    use => 'generic-service',
    check_command => 'check_http',
    host_name => "$fqdn",
    service_description => "check_http_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  define nagios::website {
    nagios_service { "$name":
      use => 'generic-service',
      check_command => "check_http_site!$name",
      host_name => "$fqdn",
      service_description => "$name",
      target => '/etc/nagios3/conf.d/nagios_service.cfg',
      notify => Service[$nagios::params::nagios_service],
    }
  }
} 
