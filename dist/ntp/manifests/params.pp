# Class: ntp::params
#
# This class contains the parameter for the ntp module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class ntp::params {

  case $operatingsystem {
    centos,redhat,fedora: {
      $ntpd_service = "ntpd"
      $driftfile    = "/var/lib/ntp/drift"
      $template     = "ntp/centos_ntp.conf.erb"
    }
    freebsd: {
      $ntpd_service = "ntpd"
      $driftfile    = "/var/db/ntpd.drift"
      $template     = "ntp/freebsd_ntp.conf.erb"
    }
    darwin: {
      $ntpd_service = "org.ntp.ntpd"
      $driftfile    = "/var/db/ntp.drift"
      $template     = "ntp/darwin_ntp.conf.erb"
    }
    debian,ubuntu: {
      $ntpd_service = "ntp"
      $driftfile    = "/var/lib/ntp/ntp.drift"
      $template     = "ntp/debian_ntp.conf.erb"
    }
    sles: {
      $ntpd_service = "ntp"
      $driftfile    = "/var/lib/ntp/drift/ntp.drift"
      $template     = "ntp/sles_ntp.conf.erb"
    }
    default: {
      fail("module ntp does not support operatingsystem $operatingsystem")
    }
  }

}

