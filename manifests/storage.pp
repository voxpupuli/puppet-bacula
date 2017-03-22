# Class: bacula::storage
#
# Configures bacula storage daemon
#
class bacula::storage (
  $port                    = '9103',
  $listen_address          = $::ipaddress,
  $storage                 = $::fqdn, # storage here is not params::storage
  $password                = 'secret',
  $device_name             = "${::fqdn}-device",
  $device                  = '/bacula',
  $device_mode             = '0770',
  $device_owner            = $bacula::params::bacula_user,
  $device_seltype          = $bacula::params::device_seltype,
  $media_type              = 'File',
  $maxconcurjobs           = '5',
  $packages                = $bacula::params::bacula_storage_packages,
  $services                = $bacula::params::bacula_storage_services,
  $homedir                 = $bacula::params::homedir,
  $rundir                  = $bacula::params::rundir,
  $conf_dir                = $bacula::params::conf_dir,
  $director                = $bacula::params::director,
  $user                    = $bacula::params::bacula_user,
  $group                   = $bacula::params::bacula_group,
) inherits bacula::params {

  include bacula::common
  include bacula::virtual

  realize(Package[$packages])

  if $ssl {
    service { $services:
      ensure    => running,
      enable    => true,
      subscribe => File[$bacula::ssl::ssl_files],
      require   => Package[$packages],
    }
  }
  else {
    service { $services:
      ensure    => running,
      enable    => true,
      require   => Package[$packages],
    }
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
    owner     => 'root',
    group     => $group,
    mode      => '0640',
    show_diff => false,
    notify    => Service[$services],
  }

  if $media_type == 'File' {
    file { $device:
      ensure  => directory,
      owner   => $device_owner,
      group   => $group,
      mode    => $device_mode,
      seltype => $device_seltype,
      require => Package[$packages],
    }
  }

  @@bacula::director::storage { $storage:
    port          => $port,
    password      => $password,
    device_name   => $device_name,
    media_type    => $media_type,
    maxconcurjobs => $maxconcurjobs,
    tag           => "bacula-${::bacula::params::storage}",
  }
}
