class zfs {

  include zfs::scrubber

  package{ 'sysutils/zfs-stats': ensure => present, }

  if defined( Class['munin'] ) {
    include zfs::munin
  }

}
