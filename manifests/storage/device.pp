# This define creates a storage device declaration.  This informs the
# storage daemon which storage devices are available to send client backups to.
#
# @param device_name     - Bacula director configuration for Device option 'Name'
# @param media_type      - Bacula director configuration for Device option 'Media Type'
# @param device          - Bacula director configuration for Device option 'Archive Device'
# @param label_media     - Bacula director configuration for Device option 'LabelMedia'
# @param random_access   - Bacula director configuration for Device option 'Random Access'
# @param automatic_mount - Bacula director configuration for Device option 'AutomaticMount'
# @param removable_media - Bacula director configuration for Device option 'RemovableMedia'
# @param always_open     - Bacula director configuration for Device option 'AlwaysOpen'
# @param maxconcurjobs   - Bacula director configuration for Device option 'Maximum Concurrent Jobs'
# @param conf_dir
# @param device_mode
# @param device_owner
# @param device_seltype
# @param director_name
# @param group
#
define bacula::storage::device (
  String           $device_name     = $name,
  String           $media_type      = 'File',
  String           $device          = '/bacula',
  Boolean          $label_media     = true,
  Boolean          $random_access   = true,
  Boolean          $automatic_mount = true,
  Boolean          $removable_media = false,
  Boolean          $always_open     = false,
  String           $maxconcurjobs   = '1', # FIXME: Change type to Integer
  String           $conf_dir        = $::bacula::conf_dir,
  Stdlib::Filemode $device_mode     = '0770',
  String           $device_owner    = $bacula::bacula_user,
  String           $device_seltype  = $bacula::device_seltype,
  String           $director_name   = $bacula::director_name,
  String           $group           = $bacula::bacula_group,
) {

  concat::fragment { "bacula-storage-device-${name}":
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-device.erb'),
  }

  if $media_type =~ '^File' {
    file { $device:
      ensure  => directory,
      owner   => $device_owner,
      group   => $group,
      mode    => $device_mode,
      seltype => $device_seltype,
    }
  }
}
