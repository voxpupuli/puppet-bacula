# Class: nagios::base
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
class nagios::base {

  include nagios::params

  @@nagios_host { $fqdn:
    ensure => present,
    alias => $hostname,
    address => $ipaddress,
    use => 'generic-host',
    target => '/etc/nagios3/conf.d/nagios_host.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_hostextinfo { $fqdn:
    ensure => present,
    icon_image_alt => $operatingsystem,
    icon_image => "base/$operatingsystem.png",
    statusmap_image => "base/$operatingsystem.gd2",
    target => '/etc/nagios3/conf.d/nagios_hostextinfo.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_ping_${hostname}":
    use => 'generic-service',
    check_command => 'check_ping!100.0,20%!500.0,60%',
    host_name => "$fqdn",
    service_description => "check_ping_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_ssh_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_ssh', 
    service_description => "check_ssh_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_dns_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_dns',
    service_description => "check_dns_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

  @@nagios_service { "check_bacula_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_bacula',
    service_description => "check_bacula_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }
}
