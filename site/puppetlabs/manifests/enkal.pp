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
class puppetlabs::enkal {
  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'

  # Base
  include puppetlabs
  include puppetlabs_ssl
  include puppetlabs::docs
  include account::master
  $ssl_path = $puppetlabs_ssl::params::ssl_path

  # Backup
  $bacula_password = 'pc08mK4Gi4ZqqE9JGa5eiOzFTDPsYseUG'
  $bacula_director = 'baal.puppetlabs.com'
  include bacula


  # Munin
  include munin

  # Jenkins
  class { "jenkins":
    site_alias => 'jenkins.puppetlabs.com',
  }

#  cron { "restart jetty": hour => 1, minute => 0,
#    command => "/etc/init.d/jetty stop; sleep 5; /etc/init.d/jetty start; /etc/init.d/apache2 restart";
#  }

  Account::User <| tag == 'developers' |>
  Group <| tag == 'developers' |>
  ssh::allowgroup { "www-data": }
}

