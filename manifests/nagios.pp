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

