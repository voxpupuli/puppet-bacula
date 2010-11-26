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
  include sudo
  Account::User <| tag == 'sysadmin' |>
  Group <| tag == 'sysadmin' |>
}
