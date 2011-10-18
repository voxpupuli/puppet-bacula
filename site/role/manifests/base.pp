class role::base {

  case $operatingsystem {
    debian:  { include puppetlabs::os::linux::debian }
    ubuntu:  { include puppetlabs::os::linux::ubuntu }
    centos:  { include puppetlabs::os::linux::centos }
    fedora:  { include puppetlabs::os::linux::fedora }
    darwin:  { include puppetlabs::os::darwin        }
    freebsd: { include puppetlabs::os::freebsd       }
    default: { }
  }

  class {
    "puppet":
      server => hiera("puppet_server"),
      agent  => false,
  }

}
