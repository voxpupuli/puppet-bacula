# Class: puppetlabs::baal
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
class puppetlabs::baal {
  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'

  # Base
  include puppetlabs
  include account::master

  # Puppet modules
  $puppet_storedconfig_password = 'password'
  $dashboard_site = 'dashboard.puppetlabs.com'
  include puppet
  include puppet::server
  include puppet::dashboard

  # Package management
  include aptrepo
  include yumrepo

  # Backup
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = 'pc08mK4Gi4ZqqE9JGa5eiOzFTDPsYseUG'
  include bacula::director
  include bacula::client
  
  # Monitoring
  include nagios::server
  include nagios::web
}
