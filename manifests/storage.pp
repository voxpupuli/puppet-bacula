# Class: bacula::storage
#
# Configures bacula storage daemon
#
class bacula::storage (
  $port                    = '9103',
  $password                = 'secret',
  $listen_address          = $::ipaddress,
  $bacula_storage          = $::fqdn,
  $device_name             = "${::fqdn}-device",
  $device                  = '/bacula',
  $media_type              = 'File',
  $packages                = $bacula::params::bacula_storage_packages,
  $services                = $bacula::params::bacula_storage_services,
  $homedir                 = $bacula::params::homedir,
  $rundir                  = $bacula::params::rundir,
  $conf_dir                = $bacula::params::conf_dir,
  $director                = $bacula::params::bacula_director,
  $volret_full             = '21 days',
  $maxvolbytes_full        = '4g',
  $maxvoljobs_full         = '10',
  $maxvols_full            = '10',
  $volret_incremental      = '8 days',
  $maxvolbytes_incremental = '4g',
  $maxvoljobs_incremental  = '50',
  $maxvols_incremental     = '10',
) inherits bacula::params {

  include bacula::common
  include bacula::ssl

  package { $packages:
    ensure => present,
  }

  service { $services:
    ensure    => running,
    enable    => true,
    subscribe => File[$bacula::ssl::ssl_files],
    require   => Package[$packages],
  }

  # Inform the director how to communicate with the storage daemon
  @@concat::fragment { "bacula-director-storage-${::fqdn}":
    target  => "${conf_dir}/conf.d/storage.conf",
    content => template('bacula/bacula-dir-storage.erb'),
    tag     => "bacula-${director}",
  }

  concat::fragment { 'bacula-storage-header':
    order   => 00,
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-header.erb'),
  }

  concat::fragment { 'bacula-storage-dir':
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-dir.erb'),
  }

  # Realize the clause the director is exporting here so we can allow access to
  # the storage daemon Adds an entry to ${conf_dir}/bacula-sd.conf
  Concat::Fragment <<| tag == "bacula-storage-dir-${director}" |>>

  concat { "${conf_dir}/bacula-sd.conf":
    owner  => 'root',
    group  => 'bacula',
    mode   => '0640',
    notify => Service[$services],
  }

  if $media_type == 'File' {
    file { $device:
      ensure => directory,
      owner  => 'bacula',
      group  => 'bacula',
      mode   => '0750',
    }
  }

  # Each storage daemon should get its own pool(s)
  @@bacula::director::pool { "${::fqdn}-Pool-Full":
    volret      => $volret_full,
    maxvolbytes => $maxvolbytes_full,
    maxvoljobs  => $maxvoljobs_full,
    maxvols     => $maxvols_full,
    label       => 'Full-',
    storage     => $bacula_storage;
  }

  @@bacula::director::pool { "${::fqdn}-Pool-Inc":
    volret      => $volret_incremental,
    maxvolbytes => $maxvolbytes_incremental,
    maxvoljobs  => $maxvoljobs_incremental,
    maxvols     => $maxvols_incremental,
    label       => 'Inc-',
    storage     => $bacula_storage;
  }
}
