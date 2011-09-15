class base {

  case $operatingsystem {
    debian:  { include puppetlabs::os::linux::debian }
    ubuntu:  { include puppetlabs::os::linux::ubuntu }
    centos:  { include puppetlabs::os::linux::centos }
    darwin:  { include puppetlabs::os::darwin        }
    freebsd: { include puppetlabs::os::freebsd       }
    default: { }
  }

  class {
    "puppet":
      server => hiera("puppet_server"),
      agent  => false
  }

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

}
