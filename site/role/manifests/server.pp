class role::server (
  $bacula = true,
  $munin  = true,
  $bacula = true
) {
  include role::base

  include postfix
  include postfix::mboxcheck # let me know that we have crap mail.

  $location = hiera("location")

  include motd  # update /etc/motd, use motd::register for more.

  # We spin up VMs all the time. We don't want to put them in munin
  # and nagios by default. We can go do this in a node if we really
  # really must, but I suspect this will very rarely happen.
  if $virtual != virtualbox {
    # Throw in some ordering, so the automatic things in, say, munin,
    # happen in the right order.
    Class['role::base'] -> Class['nagios']
    Class['role::base'] -> Class['bacula']
    Class['role::base'] -> Class['munin']
    Class['nagios']     -> Class['munin']
    Class['nagios']     -> Class['bacula']

    if ( $nagios == true ) { include nagios }
    if ( $bacula == true ) { include bacula }
    if ( $munin  == true ) { include munin  }

  }

  class { "ntp": server => hiera("ntpserver"); }

  # SSH
  ssh::allowgroup  { "sysadmin": }

  # Sudo
  sudo::allowgroup { "sysadmin": }

  # Accounts
  # This should probably be more selective on certain hosts/distros/oses
  include virtual::users
  Account::User <| tag == 'allstaff' |>
  Group         <| tag == 'allstaff' |>

  # Firewall
  if defined(Class["firewall"]) { Firewall <||> }

}
