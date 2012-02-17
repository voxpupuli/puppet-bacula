class zfs::scrubber {

  # If we have ZFS, we should scrub.
  # http://www.solarisinternals.com/wiki/index.php/ZFS_Best_Practices_Guide#Storage_Pools
  # says weekly for consumer quality drives, monthly for DC quality
  # drives. I'm going weekly to start with.
  cron{ 'zfs_scrubber':
    command => 'for x in $( zpool list -H | cut -f 1 ); do zpool scrub "${x}" ; done',
    user    => 'root',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
    hour    => '3',
    minute  => '33',
    weekday => 'sat,'
  }

}
