# This class configures the Bacula storage daemon.
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
  String              $services,
  Array[String]       $packages,
  String              $conf_dir       = $bacula::conf_dir,
  String              $device         = '/bacula',
  Stdlib::Filemode    $device_mode    = '0770',
  String              $device_name    = "${trusted['certname']}-device",
  String              $device_owner   = $bacula::bacula_user,
  String              $device_seltype = $bacula::device_seltype,
  String              $director_name  = $bacula::director_name,
  String              $group          = $bacula::bacula_group,
  String              $homedir        = $bacula::homedir,
  Optional[String]    $listen_address = $facts['ipaddress'],
  Integer             $maxconcurjobs  = 5,
  String              $media_type     = 'File',
  String              $password       = 'secret',
  Integer             $port           = 9103,
  String              $rundir         = $bacula::rundir,
  String              $storage        = $trusted['certname'], # storage here is not storage_name
  String              $address        = $facts['fqdn'],
  String              $user           = $bacula::bacula_user,
) inherits bacula {

  # Allow for package names to include EPP syntax for db_type
  $package_names = $packages.map |$p| {
    $package_name = inline_epp($p, {
      'db_type' => $bacula::db_type
    })
  }
  ensure_packages($package_names)

  service { $services:
    ensure  => running,
    enable  => true,
    require => Package[$package_names],
  }

  concat::fragment { 'bacula-storage-header':
    order   => '00',
    target  => "${conf_dir}/bacula-sd.conf",
    content => epp('bacula/bacula-sd-header.epp'),
  }

  bacula::storage::device { $device_name:
    device        => $device,
    maxconcurjobs => $maxconcurjobs,
  }

  concat::fragment { 'bacula-storage-dir':
    target  => "${conf_dir}/bacula-sd.conf",
    content => epp('bacula/bacula-sd-dir.epp'),
  }

  bacula::messages { 'Standard-sd':
    daemon   => 'sd',
    director => "${director_name}-dir = all",
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

  @@bacula::director::storage { $storage:
    address       => $address,
    port          => $port,
    password      => $password,
    device_name   => $device_name,
    media_type    => $media_type,
    maxconcurjobs => $maxconcurjobs,
    tag           => "bacula-${director_name}",
  }
}
