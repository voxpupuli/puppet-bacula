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

  $ntpd_service = $operatingsystem ? {
    centos  => "ntpd",
    freebsd => "ntpd",
    darwin  => "org.ntp.ntpd",
    default => "ntp",
  }

}
