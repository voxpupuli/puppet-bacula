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
        $bacula_director_services = [ "bacula-director", "bacula-sd" ]
        $bacula_client_packages = "bacula-client"
        $bacula_client_services = "bacula-fd"
        $client_config          = "/etc/bacula/bacula-fd.conf"
        $working_directory      = "/var/lib/bacula"
        $pid_directory          = "/var/run/bacula"
     }
     "fedora", "centos","sles": {
        $bacula_director_packages = [ "bacula-director-common", "bacula-director-mysql", "bacula-sd-mysql", "bacula-console" ]
        $bacula_director_services = [ "bacula-dir", "bacula-sd" ]
        $bacula_client_packages = "bacula-client"
        $bacula_client_services = "bacula-fd"
        $client_config          = "/etc/bacula/bacula-fd.conf"
        $working_directory      = "/var/lib/bacula"
        $pid_directory          = "/var/run/bacula"
     }
     "freebsd": {
        $bacula_client_packages = "sysutils/bacula-client"
        $bacula_client_services = "bacula-fd"
        $client_config          = "/usr/local/etc/bacula-fd.conf"
        $pid_directory          = "/var/run"
        $working_directory      = "/var/db/bacula"
     }
     default: { fail("bacula::params has no love for $operatingsystem") }
  }

}
