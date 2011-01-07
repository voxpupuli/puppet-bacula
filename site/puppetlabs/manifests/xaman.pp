# Class: puppetlabs::xaman
#
# This class installs and configures Dxul
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs::xaman {
  $mysql_root_pw = 'c2@1-mt473-ra92-p1t4ul'

  nagios::website { 'redminedev.puppetlabs.com': }

  # Munin
  include munin
  include munin::dbservices
  include munin::passenger
  include munin::puppet

  # Collectd
  include collectd::client

	include mysql::server

  # Base
  include puppetlabs
  include puppetlabs_ssl
  #include account::master
 
  redmine::unicorn { 'redminedev.puppetlabs.com':
    dir => '/opt',
    db => 'redminedevpuppetlabscom',
    db_user => 'redmine',
    db_pw => 'c@11-x5-lkajd82-as8dj2',
    port => '80',
		backup => 'false';
  }

	Account::User <| tag == 'prosvc' |>
	Group <| tag == 'prosvc' |>


}
