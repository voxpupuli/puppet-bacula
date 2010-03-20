# Class: bacula::client
#
# This class installs and configures the Bacula Backup client
#
# Parameters:
#
#
# Actions:
#   Installs the bacula-client package
#
# Requires:
#   - On CentOS the epel module
#
# Sample Usage:
#
class bacula::client {
  require bacula

  package { "bacula-client":
    ensure => present,
  }
}

