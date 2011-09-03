# Class: puppetlabs
#
# This class installs and configures the Puppet Labs base classes
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs {
  #
  # This is our base install for all of Puppet Labs servers.
  #

  # variables
  $puppet_server = hiera("puppet_server")

  ###
  # Puppet
  class {
    "puppet":
      server => "$puppet_server",
      agent  => false
  }

  # Nagios -- not sure why this is here, instead of only for the server
  include virtual::nagioscontacts

  # Packages
  if $kernel == "Linux" {
    include virtual::packages
    include packages
  }

  # SSH
  include ssh::server
  ssh::allowgroup  { "sysadmin": }

  #sudo
  include sudo
  sudo::allowgroup { "sysadmin": }

  # Accounts
  # This should probably be more selective on certain hosts/distros/oses
  include virtual::users
  Account::User <| tag == 'allstaff' |>
  Group         <| tag == 'allstaff' |>

  if defined(Class["firewall"]) { Firewall <||> }

}

