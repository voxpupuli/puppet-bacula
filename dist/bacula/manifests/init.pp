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
    $file_retention = "45 days",
    $job_retention  = "6 months",
    $autoprune      = "yes",
    $director,
    $password
  ){

  include bacula::params
  include bacula::nagios

  $bacula_director = $director
  $bacula_password = $password

  package { 'bacula-common':
    ensure => present,
  }

  package { $bacula::params::bacula_client_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_client_services:
    ensure  => running,
    enable  => true,
    require => Package[$bacula::params::bacula_client_packages],
  }

  file { '/etc/bacula/bacula-fd.conf':
    require => Package[$bacula::params::bacula_client_packages],
    content => template('bacula/bacula-fd.conf.erb'),
    notify  => Service[$bacula::params::bacula_client_services],
  }

  file { '/var/lib/bacula':
    ensure  => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }

  file { '/var/lib/bacula/mysql':
    ensure  => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }

  @@concat::fragment {
    "bacula-client-$hostname":
      target  => '/etc/bacula/bacula-dir.conf',
      content => template("bacula/bacula-dir-client.erb")
  }

  # realize the firewall rules exported from the director
  if defined (Class["firewall"]) { Firewall <<| dport == "9102" |>> }

}

