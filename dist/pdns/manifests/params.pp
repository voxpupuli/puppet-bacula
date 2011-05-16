# Class: pdns::params
#
# This class contains the parameter for the pdns module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class pdns::params {

  $pdns0_server = 'baal.puppetlabs.com'
  $pdns1_server = 'dxul.puppetlabs.com'
  $mirror0 = '74.207.250.144'
  $mirror1 = '82.113.151.205'
  $mirror2 = '74.207.228.223'

  $user = 'pdns'
  $group = 'pdns'
 
  case $operatingsystem {
    'centos', 'redhat', 'fedora': {
       $package_list = '' 
       $service_list = ''
       $conf_dir = '/etc/pdns/'
       $log_dir = '/var/log/pdns'
       $stats_dir = "$log_dir/stats"
   }
    'ubuntu', 'debian': {
       $package_list = [ 'pdns-server', 'pdns-backend-pipe', 'libgeoip-dev' ]
       $service_list = 'pdns'
       $conf_dir = '/etc/powerdns'
       $log_dir = '/var/log/powerdns'
       $stats_dir = "$log_dir/stats"
    }
    default: {
       $package_list = ''
       $service_list = ''
       $conf_dir = ''
       $log_dir = ''
       $stats_dir = ''
    }

  }
}
