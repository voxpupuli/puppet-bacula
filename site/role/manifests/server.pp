class role::server {
  include role::base

  include postfix
  include postfix::mboxcheck # let me know that we have crap mail.

  $location = hiera("location")

  include motd  # update /etc/motd, use motd::register for more.

  # We spin up VMs all the time. We don't want to put them in munin
  # and nagios by default. We can go do this in a node if we really
  # really must, but I suspect this will very rarely happen.
  if $virtual != virtualbox {
    include nagios
    class { 'munin':  munin_server => hiera("munin_server"), munin_node_address => hiera("munin_node_address"); }
    include bacula
  }

  class { "ntp": server => hiera("ntpserver"); }

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
