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
  include virtual::packages
  include virtual::nagioscontacts
  include sudo
  include packages

  ###
  # Monitoring
  #
  if $kernel == "Linux" {
    include collectd::disable
  }

  ssh::allowgroup  { "sysadmin": }
  sudo::allowgroup { "sysadmin": }

  Account::User <| tag == 'allstaff' |>
  Group         <| tag == 'allstaff' |>

  if defined(Class["firewall"]) { Firewall <||> }

}

