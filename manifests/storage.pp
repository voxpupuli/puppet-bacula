# @summary Configure a Bacula Storage Daemon
#
# This class configures the Bacula storage daemon.
#
# @param services       A list of services to operate; loaded from hiera
# @param packages       A list of packages to install; loaded from hiera
# @param conf_dir       Path to bacula configuration directory
# @param device         The system file name of the storage device managed by this storage daemon
# @param device_mode    The posix mode for device
# @param device_name    The Name that the Director will use when asking to backup or restore to or from to this device
# @param device_owner   The posix user owning the device directory
# @param device_seltype SELinux type for the device
# @param director_name  Specifies the Name of the Director allowed to connect to the Storage daemon
# @param group          The posix group for bacula
# @param homedir        The directory in which the Storage daemon may put its status files
# @param listen_address The listening IP addresses for the storage daemon
#   The notes for `bacula::client::listen_address` apply.
# @param maxconcurjobs  maximum number of Jobs that may run concurrently
# @param media_type     The type of media supported by this device
# @param password       Specifies the password that must be supplied by the named Director
# @param port           The listening port for the Storage Daemon
# @param rundir         The directory in which the Director may put its process Id file files
# @param storage        The address to be configured on the director to communicate with this storage server
# @param address        The listening address for the Storage Daemon
# @param user           The posix user for bacula
#
class bacula::storage (
  String               $services,
  Array[String]        $packages,
  Stdlib::Absolutepath $conf_dir       = $bacula::conf_dir,
  Stdlib::Absolutepath $device         = '/bacula',
  Stdlib::Filemode     $device_mode    = '0770',
  String               $device_name    = "${trusted['certname']}-device",
  String               $device_owner   = $bacula::bacula_user,
  String               $device_seltype = $bacula::device_seltype,
  String               $director_name  = $bacula::director_name,
  String               $group          = $bacula::bacula_group,
  Stdlib::Absolutepath $homedir        = $bacula::homedir,
  Array[String[1]]     $listen_address = [],
  Integer[1]           $maxconcurjobs  = 5,
  String               $media_type     = 'File',
  Bacula::Password     $password       = 'secret',
  Stdlib::Port         $port           = 9103,
  Stdlib::Absolutepath $rundir         = $bacula::rundir,
  String               $storage        = $trusted['certname'], # storage here is not storage_name
  String               $address        = $facts['networking']['fqdn'],
  String               $user           = $bacula::bacula_user,
) inherits bacula {
  # Allow for package names to include EPP syntax for db_type
  $package_names = $packages.map |$p| {
    $package_name = inline_epp($p,
      {
        'db_type' => $bacula::db_type
      }
    )
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
