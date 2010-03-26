# Class: nagios::params
#
# This class installs and configures parameters for Nagios
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::params {

       case $operatingsystem {
         "ubuntu": {
           $nagios_plugin_packages = [ 'nagios-plugins-standard', 'nagios-plugins-basic', 'nagios-plugins', 'nagios-plugins-extra' ]
           $nagios_packages = 'nagios3'
         }
         "centos": {
           $nagios_packages = [ 'nagios', 'nagios-devel' ]
           $nagios_plugin_packages = [ 'nagios-plugins-nrpe', 'nagios-plugins' ]
         }
      }

}
