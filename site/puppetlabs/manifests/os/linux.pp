class puppetlabs::os::linux {

  include packages::admin
  

  case $operatingsystem {
    debian:  { include puppetlabs::os::linux::debian }
    ubuntu:  { include puppetlabs::os::linux::ubuntu }
    centos:  { include puppetlabs::os::linux::centos }
    default: { }
  }

}
