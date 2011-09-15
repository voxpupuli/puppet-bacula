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
  #  $nrpe_server  = hiera("nrpe_server")
  #  $munin_server = hiera("munin_server")
  #  $ntpserver    = hiera("ntpserver")
  #  $location     = hiera("location")


  #  if $sp_platform_uuid {
  #    $role = hiera("role_${sp_platform_uuid}", "unknown", "roles")
  #  } else {
  #    $role = hiera("role_${hostname}", "unknown", "roles")
  #  }
  #
  #  notify { $role: }

  #
  ## Operatingsystem Specific Configurations

  #  case $operatingsystem {
  #    debian:  { include puppetlabs::os::linux::debian }
  #    ubuntu:  { include puppetlabs::os::linux::ubuntu }
  #    centos:  { include puppetlabs::os::linux::centos }
  #    darwin:  { include puppetlabs::os::darwin        }
  #    freebsd: { include puppetlabs::os::freebsd       }
  #    default: { }
  #  }

  #  case $role {
  #    workstation: { }
  #    server: {
      #      class { "nagios": nrpe_server  => hiera("nrpe_server");  }
      #      class { 'munin':  munin_server => hiera("munin_server"); }
      #
      #      # SSH
      #      include ssh::server
      #      ssh::allowgroup  { "sysadmin": }
      #
      #      # Sudo
      #      include sudo
      #      sudo::allowgroup { "sysadmin": }
      #
      #      # Accounts
      #      # This should probably be more selective on certain hosts/distros/oses
      #      include virtual::users
      #      Account::User <| tag == 'allstaff' |>
      #      Group         <| tag == 'allstaff' |>
      #
      #      # Firewall
      #      if defined(Class["firewall"]) { Firewall <||> }

      include "puppetlabs::$hostname"
      #    }
      #    unknown: { }
      #    default: { }
      #  }

  #include puppetlabs
  #  class {
  #    "puppet":
  #      server => hiera("puppet_server"),
  #      agent  => false
  #  }

  #include munin::puppet # this should be in puppet::monitor
  #  class { "ntp":    server       => hiera("ntpserver");    }

  #  case $domain {
  #    "puppetlabs.lan": {
  #      case $operatingsystem {
  #        'debian','ubuntu': {
  #          # Setup apt settings specific to the lan
  #          class { "apt::settings": proxy => hiera("proxy"); }
  #        }
  #        default: { }
  #      }
  #    }
  #
  #    "puppetlabs.com": {
  #    }
  #    default: { }
  #  }


}


