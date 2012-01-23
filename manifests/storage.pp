# Class: bacula::storage
#
#
# Parameters:
#
#
# Actions:
#  - Configures bacula storage daemon
#
# Requires:
#
# Sample Usage:
#
class bacula::storage (
    $device = '/bacula'
  ) {

  include bacula::params

  $working_directory       = $bacula::params::working_directory
  $pid_directory           = $bacula::params::pid_directory
  $bacula_director         = $bacula_director
  $bacula_storage_password = genpass('bacula_storage_password')

  package { $bacula::params::bacula_storage_packages:
    ensure => present,
  }

  service { $bacula::params::bacula_storage_services:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$bacula::params::bacula_storage_packages],
  }

  #bacula::storage::device {
  #  "${fqdn}FileStorage":
  #    device => $device,
  #}


  # Export this here so the director can realize the storage resource and know how to talk to us
  @@concat::fragment {
    "bacula-director-storage":
      order   => '00',
      target  => '/etc/bacula/bacula-dir.conf',
      content => template("bacula/bacula-dir-storage.erb"),
      tag     => "bacula-${bacula_director}",
  }

  concat::fragment {
    "bacula-storage-header":
      order   => 00,
      target  => '/etc/bacula/bacula-sd.conf',
      content => template("bacula/bacula-sd-header.erb"),
  }

  concat::fragment {
    "bacula-storage-dir":
      target  => '/etc/bacula/bacula-sd.conf',
      content => template("bacula/bacula-sd-dir.erb"),
  }

  # Realize the clause the director is exporting here so we can allow access to the storage daemon
  # Adds an entry to /etc/bacula/bacula-sd.conf
  Concat::Fragment <<| tag == "bacula-storage-dir-${bacula_director}" |>>

  concat {
    "/etc/bacula/bacula-sd.conf":
      owner   => root,
      group   => bacula,
      mode    => 640,
      notify  => Service[$bacula::params::bacula_storage_services],
  }


  file { "/bacula":
    owner   => bacula,
    group   => bacula,
    ensure  => directory,
  }

}
