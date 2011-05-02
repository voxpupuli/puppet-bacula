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

  include puppetlabs

  $lan_apt_proxy = "http://vanir.puppetlabs.lan:3142"

  # Kernel/Operatingsystem Specific Configurations
  case $kernel {
    linux:   { include puppetlabs::os::linux   }
    default: { }
  }

# Domain/Location Specific Configurations
  case $domain { 
    "puppetlabs.lan": {
      include puppetlabs::lan

      case $operatingsystem {
        debian: {
          class { "apt::settings": proxy => "$lan_apt_proxy" }
          include firewall
        }
        ubuntu: {
          class { "apt::settings": proxy => "$lan_apt_proxy" }
        }
        default: { }
      }
    }

    "puppetlabs.com": { }
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
#
#    # Dev
#    "agent01.puppetlabs.lan",
#    "agent02.puppetlabs.lan",
#    "agent03.puppetlabs.lan"
#      : { include "puppetlabs::dev::$hostname" }
#
    # Unknown
    default: { include "puppetlabs::$hostname" }

  }

}
