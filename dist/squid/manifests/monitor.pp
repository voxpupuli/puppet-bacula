class squid::monitor (
    $ensure = 'present'
) {

  include nagios::params

  @@nagios_service { "check_squid_${hostname}":
    ensure              => $ensure,
    use                 => 'generic-service',
    host_name           => $fqdn,
    check_command       => 'check_nrpe!check_proc!1:3 squid',
    service_description => "check_squid_${hostname}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify              => Service[$::nagios::params::nagios_service],
}
}
