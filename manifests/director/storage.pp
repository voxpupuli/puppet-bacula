# This define creates a storage declaration for the director.  This informs the
# director which storage servers are available to send client backups to.
#
# This resource is intended to be used from bacula::storage as an exported
# resource, so that each storage server is available as a configuration on the
# director.
#
# @param port         - Bacula director configuration for Storage option 'SDPort'
# @param password     - Bacula director configuration for Storage option 'Password'
# @param device_name  - Bacula director configuration for Storage option 'Device'
# @param media_type   - Bacula director configuration for Storage option 'Media Type'
# @param maxconcurjob - Bacula director configuration for Storage option 'Media Type'
#
define bacula::director::storage (
  String $address       = $name,
  Integer $port          = 9103,
  String $password      = 'secret',
  String $device_name   = "${::fqdn}-device",
  String $media_type    = 'File',
  Integer $maxconcurjobs = 1,
  String $conf_dir      = $bacula::conf_dir,
) {

  concat::fragment { "bacula-director-storage-${name}":
    target  => "${conf_dir}/conf.d/storage.conf",
    content => template('bacula/bacula-dir-storage.erb'),
  }
}
