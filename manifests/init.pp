# Class: bacula
#
# This class installs and configures the Bacula Backup tool
#
# Parameters:
#
#
# Actions:
#   Installs the bacula-common package
#
# Requires:
#   - On CentOS the epel module
#
# Sample Usage:
#
class bacula {

  include bacula::params

  package{'bacula-common':
    ensure   => present,
  }
}
