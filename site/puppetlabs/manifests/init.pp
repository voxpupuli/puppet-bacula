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

  include nagios
  include munin
  include ntp
  include puppet
  include ssh::server
  include virtual::users 
  include virtual::packages
  include sudo
  include packages

  ssh::allowgroup { "sysadmin": }
  sudo::allowgroup { "sysadmin": }

  Account::User <| tag == 'allstaff' |>
  Group <| tag == 'allstaff' |>

}
