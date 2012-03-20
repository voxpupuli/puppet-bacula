class zfs::snapshots {

  file { "/usr/local/bin/zfs-snapshot.rb":
    source => "puppet:///modules/os/zfs-snapshot.rb",
    owner  => root,
    group  => 0,
    mode   => 750,
  }

  cron {
    "zfs hourly snapshot":
      user        => root,
      minute      => 5,
      command     => "/usr/local/bin/zfs-snapshot.rb -r -c 25 -s hourly",
      environment => "PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin",
      require     => File["/usr/local/bin/zfs-snapshot.rb"];
    "zfs daily snapshot":
      user        => root,
      minute      => 10,
      hour        => 1,
      command     => "/usr/local/bin/zfs-snapshot.rb -r -c 8 -s daily",
      environment => "PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin",
      require     => File["/usr/local/bin/zfs-snapshot.rb"];
    "zfs weekly snapshot":
      user        => root,
      minute      => 15,
      hour        => 2,
      weekday     => 0,
      command     => "/usr/local/bin/zfs-snapshot.rb -r -c 5 -s weekly",
      environment => "PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin",
      require     => File["/usr/local/bin/zfs-snapshot.rb"];
  }

  file {
    "/usr/local/bin/zfs-snapshot.sh":
      ensure => absent,
  }
}
