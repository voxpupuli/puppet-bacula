# Class: grayskull
#
# This module manages grayskull
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class grayskull(
  $port       = 8081,
  $installdir = "/var/lib/grayskull"
) {

  motd::register { "grayskull": }
  include grayskull::jdk
  include grayskull::users
  include grayskull::proxy

}
