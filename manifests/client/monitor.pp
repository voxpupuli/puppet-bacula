class bacula::client::monitor {
  include bacula::params
  include nagios::params

  @@nagios_service { "check_baculafd_${hostname}":
    service_description      => 'Is the bacula File Daemon running?',
    use                      => 'generic-service',
    host_name                => "$fqdn",
    check_command            => 'check_nrpe!check_proc!1:1 bacula-fd',
    service_description      => "check_baculafd_${hostname}",
    target                   => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify                   => Service[$nagios::params::nagios_service],
    require                  => Service[$bacula::params::bacula_client_services],
    first_notification_delay => '120',
  }

  @@nagios_servicedependency {"check_baculafd_${hostname}":
    host_name                      => "$fqdn",
    service_description            => "check_ping_${hostname}",
    dependent_host_name            => "$fqdn",
    dependent_service_description  => "check_baculafd_${hostname}",
    execution_failure_criteria     => "n",
    notification_failure_criteria  => "w,u,c",
    ensure                         => present,
    target                         => '/etc/nagios3/conf.d/nagios_servicedep.cfg',
  }
}
