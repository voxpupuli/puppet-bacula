# This class installs VMware tools for Debian hosts, whos 'virtual' fact returns 'vmware'. 
#
#== Require
#
#Only Debian, is supported
#
# == Copyright
#
# Copyright 2011 Puppet Labs, unless otherwise noted
#
class vmware {

  if $virtual == 'vmware' {
    case $operatingsystem {
      'debian','ubntu': { include vmware::tools::debian }
      #   'centos','rhel':  { include vmware::tools::centos } # doesn't
      #   work yet.
      default:          { notice("This operating system is not supported for vmware tools instalation.") }
    }
  }

}
