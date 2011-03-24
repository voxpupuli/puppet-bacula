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

  $ntp_server = 'baal.puppetlabs.com'
  $ntpd_service = $operatingsystem ? {
    centos => "ntpd",
    default => "ntp",
  }

}
