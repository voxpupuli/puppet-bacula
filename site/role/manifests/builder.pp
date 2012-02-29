class role::builder {

  class { "role::server": nagios => false; }

  Account::User      <| title == 'jenkins' |>
  Ssh_authorized_key <| user  == 'jenkins' |>

  ssh::allowgroup  { ['release', 'builder', 'jenkins' ]: }
  ssh::allowgroup  { ['release', 'builder', 'jenkins' ]: }

  @@nagios_host { $fqdn: alias => $hostname, address =>$ipaddress, hostgroups => hiera('location'); }
  @@nagios_service { "check_ping_${hostname}": host_name => $fqdn, service_description => "check_ping_${fqdn}"; }

}
