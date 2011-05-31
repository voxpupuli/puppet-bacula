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
class bacula (
    $port           = '9102',
    $file_retention = "60 days",
    $job_retention  = "6 months",
    $autoprune      = "yes",
    $director,
    $password
  ){

  include bacula::params
  include bacula::nagios
<<<<<<< HEAD

  $bacula_director = $director
  $bacula_password = $password
=======
>>>>>>> 5538870ed354157917572471197099d7bb151ddb

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

<<<<<<< HEAD
  @@concat::fragment {
    "bacula-client-$hostname":
      target  => '/etc/bacula/bacula-dir.conf',
      content => template("bacula/bacula-dir-client.erb")
  }
=======
  if defined (Class["firewall"]) { Firewall <<| dport == "9102" |>> }
>>>>>>> 5538870ed354157917572471197099d7bb151ddb

}
