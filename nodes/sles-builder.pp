# = Node: sles-builder
#
# == Purpose
#
# Host a SLES environment for release engineering package building.
#
# == Caveats
#
# This is our single SLES box, and it is an evil monstrosity. role::server
# fails dismally since any sort of reasonable package isn't available by
# default so we just stuff a few things here. It's easier and cleaner to treat
# this as the one-off it is rather than clutter up everything else with half
# backed SLES support.
#
# I'm sorry.
#
node sles-builder {

  include role::base

  ##############################################################################
  # role::sles_server follows
  ##############################################################################
  include postfix
  include postfix::mboxcheck # let me know that we have crap mail.

  $location = hiera("location")

  include motd  # update /etc/motd, use motd::register for more.

  class { "nagios": nrpe_server  => hiera("nrpe_server");  }
  class { 'munin':  munin_server => hiera("munin_server"), munin_node_address => hiera("munin_node_address"); }
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
  ##############################################################################
  # Well that was fun.
  # I hate SLES
  # It's like RHEL, but with funny accents and even more suck.
  ##############################################################################


  ssh::allowgroup { "builder": }
  ssh::allowgroup { "release": }
  ssh::allowgroup { "techops": }

  sudo::allowgroup { "builder": }
  sudo::allowgroup { "release": }
  sudo::allowgroup { "techops": }

  # (#11486) Setup 'jenkins' user on rpm-builder
  Account::User <| title == 'jenkins' |>
  Ssh_authorized_key <| user == 'jenkins' |>
  ssh::allowgroup { "jenkins": }
  sudo::allowgroup { "jenkins": }
}
