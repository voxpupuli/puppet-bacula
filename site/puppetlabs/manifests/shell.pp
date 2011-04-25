# Class: puppetlabs::enkal
#
# This class installs and configures Shell
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::shell {
	ssh::allowgroup { "allstaff": }

  # Base
  include puppetlabs
  include account::master
  include firewall

  #include apache

  include munin
  include munin::puppet
	
  # Collectd
  include puppetlabs::server
  include collectd::client

}

