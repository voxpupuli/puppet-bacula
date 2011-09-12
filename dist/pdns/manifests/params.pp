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

  $pdns0_server = 'web01.puppetlabs.com'
  $pdns1_server = 'dxul.puppetlabs.com'

  # A note to people who has the misfortune to come across this file
  # themselves. You cannot merely add nor substract to this seeming
  # list, for it nothing more than arbitary place holders as used by a
  # template. You need to look in ../templates/docs.prb.erb to see
  # what each of these does, which has the logic in, thus making these
  # IPs pretty much futile in storing away from the rest of the
  # information in the template. - benh
  $mirror0 = '96.126.112.51'
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
