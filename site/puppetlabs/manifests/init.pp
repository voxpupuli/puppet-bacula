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

  ssh::allowgroup { "sysadmin": }
  sudo::allowgroup { "sysadmin": }

  include nagios
  include munin
  include ntp
  include puppet
  include ssh::server
  include virtual::users 
  include sudo
  include packages

	Account::User <| tag == 'allstaff' |>
	Group <| tag == 'allstaff' |>
}
