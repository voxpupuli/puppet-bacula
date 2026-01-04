# @summary Configure a Bacula Director Storage resource
#
# This define creates a storage declaration for the director.  This informs the
# director which storage servers are available to send client backups to.
#
# This resource is intended to be used from bacula::storage as an exported
# resource, so that each storage server is available as a configuration on the
# director.
#
# @param address             Bacula director configuration for Storage option 'SDAddress'
# @param port                Bacula director configuration for Storage option 'SDPort'
# @param password            Bacula director configuration for Storage option 'Password'
# @param device_name         Bacula director configuration for Storage option 'Device'
# @param media_type          Bacula director configuration for Storage option 'Media Type'
# @param max_concurrent_jobs Bacula director configuration for Storage option 'Maximum Concurrent Jobs'
# @param conf_dir            Bacula configuration directory
#
define bacula::director::storage (
  String[1]            $address             = $name,
  Stdlib::Port         $port                = 9103,
  Bacula::Password     $password            = 'secret',
  String[1]            $device_name         = "${facts['networking']['fqdn']}-device",
  String[1]            $media_type          = 'File',
  Integer[1]           $max_concurrent_jobs = 1,
  Stdlib::Absolutepath $conf_dir            = $bacula::conf_dir,
) {
  $epp_storage_variables = {
    name                => $name,
    address             => $address,
    port                => $port,
    password            => $password,
    device_name         => $device_name,
    media_type          => $media_type,
    max_concurrent_jobs => $max_concurrent_jobs,
  }

  concat::fragment { "bacula-director-storage-${name}":
    target  => "${conf_dir}/conf.d/storage.conf",
    content => epp('bacula/bacula-dir-storage.epp', $epp_storage_variables),
  }
}
