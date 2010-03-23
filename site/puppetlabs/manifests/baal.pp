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
  $bacula_director = "baal.puppetlabs.com"
  $bacula_password = "pc08mK4Gi4ZqqE9JGa5eiOzFTDPsYseUG"

  include puppetlabs
  include puppet::server
  include aptrepo
  include yumrepo
  include account::master
  include bacula::director
  include bacula::client
}
