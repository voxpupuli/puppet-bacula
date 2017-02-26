# Class: bacula::storage
#
# Configures bacula storage daemon
#
# @param conf_dir
# @param device
# @param device_mode
# @param device_password
# @param device_seltype
# @param director_name
# @param group
# @param homedir
# @param listen_address INET or INET6 address to listen on
# @param maxconcurjobs
# @param media_type
# @param packages
# @param port The listening port for the Storage Daemon
# @param rundir
# @param rundir
# @param services
# @param storage
# @param user
#
class bacula::storage (
  String $services,
  Array $packages,
  $conf_dir       = $bacula::conf_dir,
  $device         = '/bacula',
  $device_mode    = '0770',
  $device_name    = "${trusted['fqdn']}-device",
  $device_owner   = $bacula::bacula_user,
  $device_seltype = $bacula::device_seltype,
  $director_name  = $bacula::director,
  $group          = $bacula::bacula_group,
  $homedir        = $bacula::homedir,
  $listen_address = $facts['ipaddress'],
  $maxconcurjobs  = '5',
  $media_type     = 'File',
  $password       = 'secret',
  String $port    = '9103',
  $rundir         = $bacula::rundir,
  $storage        = $facts['fqdn'], # storage here is not params::storage
  $user           = $bacula::bacula_user,
) inherits ::bacula {

  # Packages are virtual due to some platforms shipping the
  # SD and Dir as part of the same package.
  include ::bacula::virtual

  # Allow for package names to include EPP syntax for db_type
  $db_type = lookup('bacula::director::db_type')
  $package_names = $packages.map |$p| {
    $package_name = inline_epp($p, {
      'db_type' => $db_type
    })
  }
  realize(Package[$package_names])

  service { $services:
    ensure  => running,
    enable  => true,
    require => Package[$package_names],
  }

  if $::bacula::use_ssl == true {
    include ::bacula::ssl
    Service[$services] {
      subscribe => File[$::bacula::ssl::ssl_files],
    }
  }

  concat::fragment { 'bacula-storage-header':
    order   => '00',
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-header.erb'),
  }

  concat::fragment { 'bacula-storage-dir':
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-dir.erb'),
  }

  bacula::messages { 'Standard-sd':
    daemon   => 'sd',
    director => "${director_name}-dir = all",
    syslog   => 'all, !skipped',
    append   => '"/var/log/bacula/bacula-sd.log" = all, !skipped',
  }

  # Realize the clause the director is exporting here so we can allow access to
  # the storage daemon Adds an entry to ${conf_dir}/bacula-sd.conf
  Concat::Fragment <<| tag == "bacula-storage-dir-${director_name}" |>>

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
    tag           => "bacula-${director_name}",
  }
}
