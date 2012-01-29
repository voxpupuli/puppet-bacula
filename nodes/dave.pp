# This is our wonderfully named DC1 firewall.
# It runs FreeBSD so we don't want it including too much for now, or
# trying to do anything too smart.

node 'dave.dc1.puppetlabs.net' {
  include role::server

  class{ 'ipsec':
    my_ip         => $::ipaddress,
    their_ip      => '74.85.255.4',
    local_subnet  => '10.0.0.0/16',
    remote_subnet => '192.168.100.0/23',
    local_router  => '10.0.42.1',
    remote_router => '192.168.100.1',
    key           => 'SacyimejhabNedinyootLeOtnemgionobfudolcodNaulufcaupAgDeumsisyicUthCopDur'
  }

  # Set periodic, so we can control a bit more what we get emailed
  # about.
  file{ '/etc/periodic.conf':
    ensure => file,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/os/freebsd/periodic.conf',
  }

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

  class { "openvpn::server":
    server => "10.0.44.0 255.255.255.0",
    route  => [
      "10.0.42.0 255.255.255.0",
      "10.0.1.0 255.255.255.0",
      "10.0.5.0 255.255.255.0",
      ],
    dns => '10.0.1.20',
  }

  openvpn::server::csc {
    "baal.puppetlabs.com":
      content => "ifconfig-push 10.0.44.9 10.0.44.10",
  }

}

