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
  $device_name     = $name,
  $media_type      = 'File',
  $device          = '/bacula',
  $label_media     = true,
  $random_access   = true,
  $automatic_mount = true,
  $removable_media = false,
  $always_open     = false,
  $maxconcurjobs   = '1',
  $conf_dir        = $::bacula::conf_dir,
  $device_mode     = '0770',
  $device_owner    = $bacula::bacula_user,
  $device_seltype  = $bacula::device_seltype,
  $director_name   = $bacula::director_name,
  $group           = $bacula::bacula_group,
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
