class role::builder {

  class { "role::server": nagios => false, bacula_monitor => false; }

  Account::User      <| title == 'jenkins' |>
  Ssh_authorized_key <| user  == 'jenkins' |>

  ssh::allowgroup   { ['release', 'builder', 'jenkins' ]: }
  sudo::allowgroup  { ['release', 'builder', 'jenkins' ]: }

  @@nagios_host    { $fqdn:
    alias      => $hostname,
    address    => $ipaddress,
    hostgroups => hiera('location'),
    use        => 'generic-host',
    target     => '/etc/nagios3/conf.d/nagios_host.cfg',
  }
  @@nagios_service { "check_ping_${hostname}":
    use                 => 'generic-service',
    host_name           => $fqdn,
    check_command       => 'check_ping!150.0,20%!500.0,60%',
    service_description => "check_ping_${fqdn}",
    target              => '/etc/nagios3/conf.d/nagios_service.cfg',
  }

}
