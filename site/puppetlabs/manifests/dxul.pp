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
  #$dashboard_site = 'demo.puppetlabs.com'
  #$puppet_storedconfig_password = 'password'

  # Puppet Forge
  include forge

  # Backup
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '9haB2+SxaNXF2C1LFdptETvihkk/zKro2Hxf+cQFEbIQ'
  include bacula

  # Nagios
  include nagios::webservices
  #nagios::website { 'demo.puppetlabs.com': }
  nagios::website { 'forge.puppetlabs.com': }
  nagios::website { 'projects.puppetlabs.com': }

  # Munin
  include munin
  include munin::dbservices
  include munin::passenger
  include munin::puppet

  # Collectd
  include collectd::client

  include mysql::server
  redmine::passenger { 'projects.puppetlabs.com':
    dir => '/opt',
    db => 'projectspuppetlabscom',
    db_user => 'redmine',
    db_pw => 'c@11-m3-m1st3r-p1t4ul',
    port => '80',
  }
}
