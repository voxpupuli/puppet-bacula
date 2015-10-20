# Define: bacula::director::storage
#

# This define creates a storage declaration for the
# director.  This informs the director which storage
# servers are available to send client backups to.
#
# This resource is intended to be used from
# bacula::storage as an exported resource, so that
# each storage server is available as a configuration
# on the director.
#
# Parameters:
# *  port         - Bacula director configuration for Storage option 'SDPort'
# *  password     - Bacula director configuration for Storage option 'Password'
# *  device_name  - Bacula director configuration for Storage option 'Device'
# *  media_type   - Bacula director configuration for Storage option 'Media Type'
# *  maxconcurjob - Bacula director configuration for Storage option 'Media Type'
#
define bacula::director::storage (
  $port          = '9103',
  $password      = 'secret',
  $device_name   = "${::fqdn}-device",
  $media_type    = 'File',
  $maxconcurjobs = '1',
  $conf_dir      = $bacula::params::conf_dir, # Overridden at realize
) {

  include bacula::params

  concat::fragment { "bacula-director-storage-${name}":
    target  => "${conf_dir}/conf.d/storage.conf",
    content => template('bacula/bacula-dir-storage.erb'),
  }
}
