# Class: bacula::storage
#
#
# Parameters:
#
#
# Actions:
#  - Configures bacula storage daemon
#
# Requires:
#
# Sample Usage:
#
class bacula::storage (
    $password,
    $device = '/bacula'
  ) {


  bacula::storage::device {
    "${fqdn}FileStorage":
      device => '/bacula',
  }

}
