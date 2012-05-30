# = Class: bacula::common
#
# == Description
#
# This class configures and installs the bacula client packages and enables
# the service, so that bacula jobs can be run on the client including this
# manifest.
#
class bacula::common {
  include bacula::params

  $bacula_director   = $bacula::params::bacula_director
  $bacula_is_storage = $bacula::params::bacula_is_storage
  $listen_address    = $bacula::params::listen_address
  $working_directory = $bacula::params::working_directory
  $pid_directory     = $bacula::params::pid_directory
  $bacula_password   = $bacula::params::bacula_password
  $client_config     = $bacula::params::client_config

  package { $bacula::params::bacula_client_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_client_services:
    ensure  => running,
    enable  => true,
    require => Package[$bacula::params::bacula_client_packages],
  }

  file { $bacula::params::client_config:
    require => Package[$bacula::params::bacula_client_packages],
    content => template('bacula/bacula-fd.conf.erb'),
    notify  => Service[$bacula::params::bacula_client_services],
  }

  file { $bacula::params::working_directory:
    ensure  => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }

}
