# Class: bacula::client
#
# This class installs and configures the Bacula Backup client
#
# Parameters:
#  - $bacula_director
#  - $bacula_password
#
# Actions:
#   - Installs the bacula-client package
#   - Starts the Bacula client services
#
# Requires:
#
# Sample Usage:
#
class bacula::client {
  require bacula

  package { $bacula::params::bacula_client_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_client_services:
    ensure => running,
    enable => true,
    require => Package[$bacula::params::bacula_client_packages],
  }
}

