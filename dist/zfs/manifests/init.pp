class zfs {

  include zfs::scrubber

  package{ 'sysutils/zfs-stats': ensure => present, }

}
