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

       $nrpe_server = '74.207.240.137'

       case $operatingsystem {
         "ubuntu": {
           $nagios_plugin_packages = [ 'nagios-plugins-standard', 'nagios-plugins-basic', 'nagios-plugins', 'nagios-plugins-extra', 'nagios-nrpe-plugin' ]
           $nrpe_packages = 'nagios-nrpe-server'
           $nrpe_service = 'nagios-nrpe-server'
           $nrpe_configuration = '/etc/nagios/nrpe.cfg'
           $nagios_packages = 'nagios3'
           $nagios_service = 'nagios3'
         }
         "centos": {
           $nagios_packages = [ 'nagios', 'nagios-devel' ]
           $nagios_plugin_packages = [ 'nagios-plugins-nrpe', 'nagios-plugins' ]
           $nagios_service = 'nagios'
         }
      }

}
