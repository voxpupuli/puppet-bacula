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

  ###
  # Puppet
  $puppet_server = "baal.puppetlabs.com"
  class { "puppet": server => "$puppet_server"; }

  # some shit
  include ssh::server
  include virtual::users
  include virtual::nagioscontacts
  include sudo
  if $kernel == "Linux" {
    include virtual::packages
    include collectd::disable
    include packages
  }


  ssh::allowgroup  { "sysadmin": }
  sudo::allowgroup { "sysadmin": }

  Account::User <| tag == 'allstaff' |>
  Group         <| tag == 'allstaff' |>

  if defined(Class["firewall"]) { Firewall <||> }

}

