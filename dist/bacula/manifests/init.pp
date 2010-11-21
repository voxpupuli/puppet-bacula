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
#
# Sample Usage:
#
class bacula {

  include bacula::params

  package { 'bacula-common':
    ensure => present,
  }

  package { $bacula::params::bacula_client_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_client_services:
    ensure => running,
    enable => true,
    require => Package[$bacula::params::bacula_client_packages],
  }

  file { '/etc/bacula/bacula-fd.conf':
    require => Package[$bacula::params::bacula_client_packages],
    content => template('bacula/bacula-fd.conf.erb'),
    notify => Service[$bacula::params::bacula_client_services],
  }

  file { '/var/lib/bacula':
    ensure => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }

  file { '/var/lib/bacula/mysql':
    ensure => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }
}
