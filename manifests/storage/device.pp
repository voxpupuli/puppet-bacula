define bacula::storage::device (
  $device_type = 'File',
  $device, # The path to the device or storage directory
  $conf_dir = $bacula::params::conf_dir,
  $maxconcurjobs = undef,
) {
  validate_re($device_type, ['^File', '^Tape', '^Fifo'])

  concat::fragment { "bacula-storage-device-${name}":
    target  => "${conf_dir}/bacula-sd.conf",
    content => template('bacula/bacula-sd-device.erb'),
  }
}