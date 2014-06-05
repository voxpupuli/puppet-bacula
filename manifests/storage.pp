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
    $port                    = '9103',
    $device_name             = "${::fqdn}-device",
    $device                  = '/bacula',
    $media_type              = 'File',
    $working_directory       = $bacula::params::working_directory,
    $pid_directory           = $bacula::params::pid_directory,
    $bacula_director         = $bacula::params::bacula_director
) inherits bacula::params {

  include bacula::common

  $bacula_storage_password = genpass({store_key => 'bacula_storage_password'})
  $bacula_storage = $bacula::params::bacula_storage
  $listen_address = hiera('bacula_client_listen')

  package { $bacula::params::bacula_storage_packages: ensure => present; }

  service { $bacula::params::bacula_storage_services:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$bacula::params::bacula_storage_packages],
  }

  # Export this here so the director can realize the storage resource and know how to talk to us
  @@concat::fragment {
    "bacula-director-storage-${::fqdn}":
      target  => '/etc/bacula/conf.d/storage.conf',
      content => template('bacula/bacula-dir-storage.erb'),
      tag     => "bacula-${bacula_director}",
      require => Package[$bacula::params::bacula_storage_packages]
  }

  concat::fragment {
    'bacula-storage-header':
      order   => 00,
      target  => '/etc/bacula/bacula-sd.conf',
      content => template('bacula/bacula-sd-header.erb'),
  }

  concat::fragment {
    'bacula-storage-dir':
      target  => '/etc/bacula/bacula-sd.conf',
      content => template('bacula/bacula-sd-dir.erb'),
  }

  # Realize the clause the director is exporting here so we can allow access to the storage daemon
  # Adds an entry to /etc/bacula/bacula-sd.conf
  Concat::Fragment <<| tag == "bacula-storage-dir-${bacula_director}" |>>
  concat {
    '/etc/bacula/bacula-sd.conf':
      owner   => root,
      group   => bacula,
      mode    => 640,
      notify  => Service[$bacula::params::bacula_storage_services],
      require => Package[$bacula::params::bacula_storage_packages],
  }

  file { $device:
    ensure  => directory,
    owner   => bacula,
    group   => bacula,
    require => Package[$bacula::params::bacula_storage_packages],
  }

  # Each storage daemon should get its own pool(s)
  @@bacula::director::pool {
    "${::fqdn}-Pool-Full":
      volret      => '21 days',
      maxvolbytes => '4g',
      maxvoljobs  => '10',
      maxvols     => '100',
      label       => 'Full-',
      storage     => $bacula_storage;
    "${::fqdn}-Pool-Inc":
      volret      => '8 days',
      maxvolbytes => '4g',
      maxvoljobs  => '50',
      maxvols     => '100',
      label       => 'Inc-',
      storage     => $bacula_storage;
  }

}
