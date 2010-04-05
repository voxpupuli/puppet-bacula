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
           $nagios_plugin_packages = [ 'nagios-plugins-standard', 'nagios-plugins-basic', 'nagios-plugins', 'nagios-plugins-extra', 'nagios-nrpe-plugin' ]
           $nagios_packages = [ 'nagios3', 'nagios-nrpe-server' ]
           $nagios_service = [ 'nagios3', 'nagios-nrpe-server' ]
         }
         "centos": {
           $nagios_packages = [ 'nagios', 'nagios-devel' ]
           $nagios_plugin_packages = [ 'nagios-plugins-nrpe', 'nagios-plugins' ]
           $nagios_service = 'nagios'
         }
      }

}
