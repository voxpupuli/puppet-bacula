# Class: puppetlabs::enkal
#
# This class installs and configures Baal
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
  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4a1'

  # Base
  include puppetlabs
  include account::master

  # Puppet modules
  $dashboard_site = 'pupdemo2.puppetlabs.com'
  #include puppet::server
  include puppet::dashboard
	include hudson::slave
	
	Account::User <| tag == 'prosvc' |>
	Group <| tag == 'prosvc' |>
	Account::User <| tag == 'developers' |>
	Group <| tag == 'developers' |>

}

