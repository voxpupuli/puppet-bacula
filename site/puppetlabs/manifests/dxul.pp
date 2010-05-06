# Class: puppetlabs::dxul
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
class puppetlabs::dxul {
  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'

  # Base
  include puppetlabs
  include account::master
 
  # Puppet
  $dashboard_site = 'demo.puppetlabs.com'
  $puppet_storedconfig_password = 'password'
  include puppet

  # Backup
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '9haB2+SxaNXF2C1LFdptETvihkk/zKro2Hxf+cQFEbIQ'
  include bacula

  # Nagios
  include nagios::webservices
  nagios::website { 'demo.puppetlabs.com': }

  # Munin
  include munin
  include munin::dbservices
  include munin::passenger
  include munin::puppet

  # Collectd
  include collectd::client
}
