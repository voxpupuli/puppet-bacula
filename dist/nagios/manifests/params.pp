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
    }
    "debian": {
      $nagios_plugin_packages = [ 'nagios-plugins-standard', 'nagios-plugins-basic', 'nagios-plugins', 'nagios-nrpe-plugin' ]
    }
  }

  case $operatingsystem {
    "ubuntu","debian": {
      $nrpe_packages      = 'nagios-nrpe-server'
      $nrpe_service       = 'nagios-nrpe-server'
      $nrpe_configuration = '/etc/nagios/nrpe.cfg'
      $nrpe_pid           = '/var/run/nagios/nrpe.pid'
      $nrpe_user          = 'nagios'
      $nrpe_group         = 'nagios'
      $nagios_packages    = 'nagios3'
      $nagios_service     = 'nagios3'
      $nagios_plugins_path = "/usr/lib/nagios/plugins"
    }
    "sles": { # FIXME sles stub
      $nagios_packages        = [ 'nagios', 'nagios-devel' ]
      $nrpe_packages          = 'nagios-nrpe'
      $nrpe_configuration     = '/etc/nagios/nrpe.cfg'
      $nrpe_pid               = '/var/run/nrpe/nrpe.pid'
      $nrpe_user              = 'nrpe'
      $nrpe_group             = 'nrpe'
      $nrpe_service           = 'nrpe'
      $nagios_plugin_packages = 'nagios-plugins'
      $nagios_service         = 'nagios3'
      $nagios_plugins_path    = "/usr/lib/nagios/plugins"
    }
    "centos","fedora": {
      $nagios_packages        = [ 'nagios', 'nagios-devel' ]
      $nrpe_packages          = 'nrpe'
      $nrpe_configuration     = '/etc/nagios/nrpe.cfg'
      $nrpe_pid               = '/var/run/nrpe/nrpe.pid'
      $nrpe_user              = 'nrpe'
      $nrpe_group             = 'nrpe'
      $nrpe_service           = 'nrpe'
      $nagios_plugin_packages = [ 'nagios-plugins-nrpe', 'nagios-plugins', 'nagios-plugins-all' ]
      $nagios_service         = 'nagios3'
      case $architecture {
        "x86_64": {
          $nagios_plugins_path = "/usr/lib64/nagios/plugins"
        }
        "i386": {
          $nagios_plugins_path = "/usr/lib/nagios/plugins"
        }
      }
    }
    "darwin": { 
      $nrpe_packages          = 'nrpe'
      $nrpe_service           = 'org.macports.nrpe'
      $nrpe_configuration     = '/opt/local/etc/nrpe/nrpe.cfg'
      $nrpe_pid               = '/var/run/nrpe.pid'
      $nrpe_user              = 'nagios'
      $nrpe_group             = 'nagios'
      $nagios_packages        = 'nagios'
      $nagios_service         = 'nagios3' # <-- broken on osx agents because it actually needs to be the server's service
      $nagios_plugins_path    = "/usr/lib/nagios/plugins"
      $nagios_plugin_packages = 'nagios-plugins'
    }
    default: {
      fail("module nagios does not support operatingsystem $operatingsystem")
    }
  }

}
