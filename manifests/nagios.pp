# Class: bacula::nagios
#
# This class shoves a resource for monitoring the state of backups for the given host into stored configs for later consumption on the nagios monitoring system
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class bacula::nagios {
  include bacula::params

  @@nagios_service { "check_bacula_${hostname}":
    use                 => 'generic-service',
    host_name           => "$fqdn",
    check_command       => 'check_bacula',
    service_description => "check_bacula_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$nagios::params::nagios_service],
  }

}

