class role::server {
  include role::base

  include postfix

  $location = hiera("location")

  class { "nagios": nrpe_server  => hiera("nrpe_server");  }
  class { 'munin':  munin_server => hiera("munin_server"); }
  class { "ntp":    server       => hiera("ntpserver"); }

  # SSH
  include ssh::server
  ssh::allowgroup  { "sysadmin": }

  # Sudo
  include sudo
  sudo::allowgroup { "sysadmin": }

  # Accounts
  # This should probably be more selective on certain hosts/distros/oses
  include virtual::users
  Account::User <| tag == 'allstaff' |>
  Group         <| tag == 'allstaff' |>

  # Firewall
  if defined(Class["firewall"]) { Firewall <||> }
}
