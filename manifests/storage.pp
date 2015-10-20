# Class: bacula::storage
#
# Configures bacula storage daemon
#
class bacula::storage (
  $port                    = '9103',
  $listen_address          = $::ipaddress,
  $storage                 = $::fqdn,
  $password                = 'secret',
  $device_name             = "${::fqdn}-device",
  $device                  = '/bacula',
  $device_owner            = $bacula::params::bacula_user,
  $media_type              = 'File',
  $packages                = $bacula::params::bacula_storage_packages,
  $services                = $bacula::params::bacula_storage_services,
  $homedir                 = $bacula::params::homedir,
  $rundir                  = $bacula::params::rundir,
  $conf_dir                = $bacula::params::conf_dir,
  $director                = $bacula::params::director,
  $user                    = $bacula::params::bacula_user,
  $group                   = $bacula::params::bacula_group,
  $volret_full             = '21 days',
  $volret_incremental      = '8 days',
  $maxconcurjobs           = '5',
  $maxvolbytes_full        = '4g',
  $maxvoljobs_full         = '10',
  $maxvols_full            = '10',
  $maxvolbytes_incremental = '4g',
  $maxvoljobs_incremental  = '50',
  $maxvols_incremental     = '10',
) inherits bacula::params {

  include bacula::common
  include bacula::ssl
  include bacula::virtual

  realize(Package[$packages])

  service { $services:
    ensure    => running,
    enable    => true,
    subscribe => File[$bacula::ssl::ssl_files],
    require   => Package[$packages],
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

  bacula::messages { 'Standard-sd':
    daemon   => 'sd',
    director => "${director}-dir = all",
    syslog   => 'all, !skipped',
    append   => '"/var/log/bacula/bacula-sd.log" = all, !skipped',
  }

  # Realize the clause the director is exporting here so we can allow access to
  # the storage daemon Adds an entry to ${conf_dir}/bacula-sd.conf
  Concat::Fragment <<| tag == "bacula-storage-dir-${director}" |>>

  concat { "${conf_dir}/bacula-sd.conf":
    owner  => 'root',
    group  => $group,
    mode   => '0640',
    notify => Service[$services],
  }

  if $media_type == 'File' {
    file { $device:
      ensure  => directory,
      owner   => $device_owner,
      group   => $group,
      mode    => '0770',
      require => Package[$packages],
    }
  }

  @@bacula::director::storage { "${storage}-sd":
    port          => $port,
    password      => $password,
    device_name   => $device_name,
    media_type    => $media_type,
    storage       => $storage,
    maxconcurjobs => $maxconcurjobs
  }

  # Each storage daemon should get its own pool(s)
  @@bacula::director::pool { "${storage}-Pool-Full":
    volret      => $volret_full,
    maxvolbytes => $maxvolbytes_full,
    maxvoljobs  => $maxvoljobs_full,
    maxvols     => $maxvols_full,
    label       => 'Full-',
    storage     => $storage;
  }

  @@bacula::director::pool { "${storage}-Pool-Inc":
    volret      => $volret_incremental,
    maxvolbytes => $maxvolbytes_incremental,
    maxvoljobs  => $maxvoljobs_incremental,
    maxvols     => $maxvols_incremental,
    label       => 'Inc-',
    storage     => $storage;
  }
}
