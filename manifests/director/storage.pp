# Define: bacula::director::storage
#

# This define creates a storage declaration for the
# director.  This informs the director which storage
# servers are available to send client backups to.
# This resource is intended to be used from
# bacula::storage as an exported resource, so that
# each storage server is available as a configuration
# on the director.
#
# Parameters:
# *  port        - Bacula storage configuration option 'SDPort'
# *  password    - Bacula storage configuration option 'Password'
# *  device_name - Bacula storage configuration option 'Device'
# *  media_type  - Bacula storage configuration option 'Media Type'
#
define bacula::director::storage (
  $port        = '9103',
  $password    = 'secret',
  $storage     = $::fqdn,
  $device_name = "${::fqdn}-device",
  $media_type  = 'File',
  $conf_dir    = $bacula::params::conf_dir, # Overridden at realize
) {

  include bacula::params

  concat::fragment { "bacula-director-storage-${storage}":
    target  => "${conf_dir}/conf.d/storage.conf",
    content => template('bacula/bacula-dir-storage.erb'),
  }
}
