# Definition: sysctl::value 
#
# Description
#  This definition is configured to set a sysctl value via a custom type/provider,
#  and ensure that a sysctl value is enforced immediately. 
#
# Parameters:
#  - $value: the defined value for the sysctl parameter
#
# Actions:
#  Creates a new line in /etc/sysctl.conf for enforcement at reboot, and
#  reloads sysctl to ensure immediate enforcement.
#
# Requires:
#   This module has no requirements.
#
# Sample Usage:
#   sysctl::value{ 'net.ipv4.ip_forward': 
#     value => '1',
#   }
#
define sysctl::value(
  $value
) {
  include sysctl

  sysctl { $name:
    val => $value,
    notify => Exec['reload-sysctl'],
  }
}
