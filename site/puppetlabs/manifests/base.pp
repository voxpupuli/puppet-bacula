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

  ###
  # Stages
  #

  #
  ## Kernel/Operatingsystem Specific Configurations
  case $kernel {
    linux:   { include puppetlabs::os::linux   }
    default: { }
  }

  #
  ## Domain/Location Specific Configurations

  # We only want munin in production environments
  if $environment == 'production' {
    class { 'munin':
      munin_server => $domain ? {
        'puppetlabs.lan' => '192.168.101.9',
        'puppetlabs.com' => '173.255.196.32',
        default          => '127.0.0.1',  # A crap default, but
                                          # security wise, safer.
      }
    }
    include munin::puppet
  }

  #
  case $domain {
    "puppetlabs.lan": {
      $lan_apt_proxy = "http://vanir.puppetlabs.lan:3142"
      include puppetlabs

      case $operatingsystem {
        'debian','ubuntu': {
          # Setup apt settings specific to the lan
          class { "apt::settings": proxy => "$lan_apt_proxy" }
        }
        default: { }
      }
    }

    "puppetlabs.com": {
      include puppetlabs
      # zleslie: Nagios should be moved at a higher level, but need to work out nrpe through the firewall
      class { "nagios": nrpe_server => '173.255.196.32'; }
      # zleslie: need to check ntp to make sure that it is completely seperated from all other things and can be included on lan
      include ntp

    }
    default: { }
  }

  case $hostname {
    # Known
    "app01",
    "baal",
    "bacula01",
    "burji",
    "clippy",
    "deb-builder",
    "dxul",
    "enkal",
    "faro",
    "forge-dev",
    "lukedev01",
    "metrics",
    "mon0",
    "net01",
    "ningyo",
    "pluto",
    "projects-dev",
    "projects2-dev",
    "qa",
    "rpm-builder",
    "shell",
    "slave01",
    "slave02",
    "tb-driver",
    "urd",
    "vanir",
    "web01",
    "www-dev",
    "wyrd",
    "yo",
      : { include "puppetlabs::$hostname" }
    # Unknown
    default: { }

  }

}

