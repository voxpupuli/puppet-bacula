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
  # This is our base install for all of our servers.
  #

  include ntp
  include puppet
  include ssh::server
  include virtual::users
  include virtual::packages
  include virtual::nagioscontacts
  include sudo
  include packages

  class { "collectd::client": server       => "baal.puppetlabs.com"; }
  class { "nagios":           nrpe_server  => '74.207.240.137'; }
  class { "munin":            munin_server => '74.207.240.137'; }

  ssh::allowgroup  { "sysadmin": }
  sudo::allowgroup { "sysadmin": }

  Account::User <| tag == 'allstaff' |>
  Group <| tag == 'allstaff' |>

  if defined(Class["firewall"]) { Firewall <||> }

}

