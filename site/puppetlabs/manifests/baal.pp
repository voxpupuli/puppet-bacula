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
  $bacula_password = 'pc08mK4Gi4ZqqE9JGa5eiOzFTDPsYseUG'
  $bacula_director = 'baal.puppetlabs.com'
  include bacula
  include bacula::director
  
  # Monitoring
  include nagios::server
  include nagios::webservices
  nagios::website { 'apt.puppetlabs.com': }
  nagios::website { 'yum.puppetlabs.com': }
  nagios::website { 'nagios.puppetlabs.com': auth => 'monit:5kUg8uha', }
  nagios::website { 'dashboard.puppetlabs.com': auth => 'monit:5kUg8uha', }
}
