# Class: nagios::web
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
class nagios::web {

  @@nagios_service { "check_http_${hostname}":
    use => 'generic-service',
    check_command => 'check_http',
    host_name => "$fqdn",
    service_description => "check_http_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

}
