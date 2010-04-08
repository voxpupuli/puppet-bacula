# Class: nagios::db
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
class nagios::db {

  @@nagios_service { "check_mysql_${hostname}":
    use => 'generic-service',
    check_command => 'check_mysql',
    host_name => "$fqdn",
    service_description => "check_mysql_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

}
