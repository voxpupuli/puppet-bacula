# Class: puppetlabs::base
#
# This class is meant to be the root clase from which all other calsses are called.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   include puppetlabs::base
#
class puppetlabs::base {

  #
  # Hiera data
  $nrpe_server  = hiera("nrpe_server")
  $munin_server = hiera("munin_server")
  $ntpserver    = hiera("ntpserver")
  $location     = hiera("location")
  $role         = hiera("role")

  #
  ## Operatingsystem Specific Configurations

  case $operatingsystem {
    debian:  { include puppetlabs::os::linux::debian }
    ubuntu:  { include puppetlabs::os::linux::ubuntu }
    centos:  { include puppetlabs::os::linux::centos }
    darwin:  { include puppetlabs::os::darwin  }
    freebsd: { include puppetlabs::os::freebsd }
    default: { }
  }

  #include puppetlabs
  class {
    "puppet":
      server => hiera("puppet_server"),
      agent  => false
  }

  #include munin::puppet # this should be in puppet::monitor
  #class { "nagios": nrpe_server  => hiera("nrpe_server");  }
  # class { 'munin':  munin_server => hiera("munin_server"); }
  class { "ntp":    server       => hiera("ntpserver");    }

  case $domain {
    "puppetlabs.lan": {
      case $operatingsystem {
        'debian','ubuntu': {
          # Setup apt settings specific to the lan
          class { "apt::settings": proxy => hiera("proxy"); }
        }
        default: { }
      }
    }

    "puppetlabs.com": {
    }
    default: { }
  }

  #include "puppetlabs::$hostname"

}


