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

  include puppetlabs
  #include munin::puppet # this should be in puppet::monitor
  class { "nagios": nrpe_server  => $nrpe_server;  }
  class { 'munin':  munin_server => $munin_server; }
  class { "ntp":    server       => $ntp_server;   }

  case $domain {
    "puppetlabs.lan": {
      $lan_apt_proxy = "http://modi.puppetlabs.lan:3142"

      case $operatingsystem {
        'debian','ubuntu': {
          # Setup apt settings specific to the lan
          class { "apt::settings": proxy => "$lan_apt_proxy" }
        }
        default: { }
      }
    }

    "puppetlabs.com": {
    }
    default: { }
  }

  case $hostname {
    #    # Known
    #    "app01",
    #    "baal",
    #    "bacula01",
    #    "burji",
    #    "clippy",
    #    "deb-builder",
    #    "dxul",
    #    "enkal",
    #    "faro",
    #    "forge-dev",
    #    "lukedev01",
    #    "metrics",
    #    "mon0",
    #    "net01",
    #    "ningyo",
    #    "pluto",
    #    "projects-dev",
    #    "projects2-dev",
    #    "qa",
    #    "rpm-builder",
    #    "shell",
    #    "slave01",
    #    "slave02",
    #    "tb-driver",
    #    "urd",
    #    "vanir",
    #    "web01",
    #    "www-dev",
    #    "wyrd",
    #    "yo"
    #      : { include "puppetlabs::$hostname" }
    # Unknown
    default: { include "puppetlabs::$hostname" }

  }

}


