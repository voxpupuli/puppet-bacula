# Class: bacula::params
#
# This class contains the Bacula module parameters
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class bacula::params {
  
  case $operatingsystem {
     "ubuntu","debian": {
        $bacula_director_packages = [ "bacula-director-common", "bacula-director-mysql", "bacula-sd-mysql", "bacula-console" ]
        $bacula_director_services = [ "bacula-dir", "bacula-sd" ]
        $bacula_client_packages = "bacula-client"
        $bacula_client_services = "bacula-fd"
     }
     "centos": {
        $bacula_director_packages = [ "bacula-director-common", "bacula-director-mysql", "bacula-sd-mysql", "bacula-console" ]
        $bacula_director_services = [ "bacula-dir", "bacula-sd" ]
        $bacula_client_packages = "bacula-client"
        $bacula_client_services = "bacula-fd"
     }
  }

}
