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
  $bacula_director = "baal.puppetlabs.com"
  $bacula_password = "9haB2+SxaNXF2C1LFdptETvihkk/zKro2Hxf+cQFEbIQ"

  include puppetlabs
  include puppet
  include puppet::server
  include puppet::dashboard
  include account::master
  include bacula::client
}
