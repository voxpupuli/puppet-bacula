class puppetlabs::base {

  $lan_apt_proxy = "http://vanir.puppetlabs.lan:3142"

  # Kernel/Operatingsystem Specific Configurations
  case $kernel {
    linux:   { include puppetlabs::os::linux   }
    default: { }
  }

# Domain/Location Specific Configurations
  case $domain { 
    "puppetlabs.lan": {
      case $operatingsystem {
        debian: {
          class { "apt::settings": proxy => "$lan_apt_proxy" }
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
#    # Production
#    "apu.puppetlabs.com",
#    "baal.puppetlabs.com",
#    "dxul.puppetlabs.com",
#    "chuku.puppetlabs.com",
#    "enkal.puppetlabs.com",
#    "legba.puppetlabs.com",
#    "shell.puppetlabs.com",
#    "app01.puppetlabs.com"
#      : { include "puppetlabs::prod::$hostname" }
#
#    # Dev
#    "agent01.puppetlabs.lan",
#    "agent02.puppetlabs.lan",
#    "agent03.puppetlabs.lan"
#      : { include "puppetlabs::dev::$hostname" }
#
#    # Unknown -- Assume Production
#    default: { include "puppetlabs::prod::$hostname" }
    default: { include "puppetlabs::$hostname" }

  }

}
