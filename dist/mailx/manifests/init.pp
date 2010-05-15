# Class: mailx
#
# This class installs and configures parameters for Mailx
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mailx {
  package{'mailx':
    ensure => installed,
  }
}
