# Class: bacula::director
#
# This class installs and configures the Bacula Backup Director
#
# Parameters:
#
#
# Actions:
#   Installs the bacula-director-common package
#
# Requires:
#   - On CentOS the epel module
#
# Sample Usage:
#
class bacula::director {
  require bacula

  package { [ "bacula-director-common", "bacula-console" ]: 
    ensure => present,
  }

