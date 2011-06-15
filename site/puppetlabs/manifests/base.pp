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
  case $domain {
    "puppetlabs.lan": {
      $lan_apt_proxy = "http://vanir.puppetlabs.lan:3142"
      include puppetlabs

      case $operatingsystem {
        'debian','ubuntu': {
          # Setup apt settings specific to the lan
          class { "apt::settings": proxy => "$lan_apt_proxy" }
        }
        'centos': {
          include puppetlabs::lan::yum
        }
        default: { }
      }
    }

    "puppetlabs.com": {
      include puppetlabs
      # zleslie: same issue as nagios below, a vpn would solve this
      class { "munin":  munin_server => '74.207.240.137'; }
      # zleslie: Nagios should be moved at a higher level, but need to work out nrpe through the firewall
      class { "nagios": nrpe_server => '74.207.240.137'; }
      # zleslie: need to check ntp to make sure that it is completely seperated from all other things and can be included on lan
      include ntp

    }
    default: { }
  }

  case $fqdn {
    # Known
#    "apu.puppetlabs.com",
#    "baal.puppetlabs.com",
#    "dxul.puppetlabs.com",
#    "chuku.puppetlabs.com",
#    "enkal.puppetlabs.com",
#    "legba.puppetlabs.com",
#    "shell.puppetlabs.com",
#    "app01.puppetlabs.com"
#      : { include "puppetlabs::$hostname" }
    # Unknown
    default: { include "puppetlabs::$hostname" }

  }

}
