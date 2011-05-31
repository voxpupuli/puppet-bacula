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

#  $puppet_server = "baal.puppetlabs.com"

  include ntp
  #include puppet
#  class { "puppet": server => "$puppet_server"; }
  include ssh::server
  include virtual::users
  include virtual::packages
  include virtual::nagioscontacts
  include sudo
  include packages

# remove collectd in favor of munin Tue May 31 2011 10:23:55
# zleslie:  $collectd_server = "baal.puppetlabs.com"
# zleslie:  # Collectd -- The collectd module should probably handle this will paramters
# zleslie:  if $fqdn == $collectd_server {
# zleslie:    class { "collectd::server": site_alias => "visage.puppetlabs.com"; }
# zleslie:  } else {
# zleslie:    class { "collectd::client": collectd_server => "baal.puppetlabs.com"; }
# zleslie:  }

  include collectd::disable


  class { "nagios":           nrpe_server  => '74.207.240.137'; }
  class { "munin":            munin_server => '74.207.240.137'; }

  ssh::allowgroup  { "sysadmin": }
  sudo::allowgroup { "sysadmin": }

  Account::User <| tag == 'allstaff' |>
  Group <| tag == 'allstaff' |>

  if defined(Class["firewall"]) { Firewall <||> }

}

