# This is our wonderfully named DC1 firewall.
# It runs FreeBSD so we don't want it including too much for now, or
# trying to do anything too smart.

node 'dave.dc1.puppetlabs.net' {
  include role::base

  # Accounts
  # This should probably be more selective on certain hosts/distros/oses
  include virtual::users
  Account::User <| groups == 'sysadmin' |>
  Group         <| tag == 'allstaff' |>

  include ntp

  include postfix
  include postfix::mboxcheck

  include motd
  motd::register{"the god damn firewall!": }

  include sudo
  sudo::allowgroup { 'sysadmin': }

  class{ 'ipsec':
    my_ip         => $::ipaddress,
    their_ip      => '74.85.255.4',
    local_subnet  => '10.0.42.0/24',
    remote_subnet => '192.168.100.0/24',
    local_router  => '10.0.42.1',
    remote_router => '192.168.100.1',
    key           => 'SacyimejhabNedinyootLeOtnemgionobfudolcodNaulufcaupAgDeumsisyicUthCopDur'
  }

  # Make this a template, please.
  file{ '/etc/periodic.conf':
    ensure => file,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/os/freebsd/periodic.conf',
  }

  file {
    "/usr/local/bin/zfs-snapshot.sh":
      owner => root,
      group => 0,
      mode =>  750,
      source => "puppet:///puppetlabs/zfs-snapshot.sh";
  }

  cron {
    "zfs hourly snapshot":
      ensure  => absent,
      user    => root,
      minute  => 0,
      command => "/usr/local/bin/zfs-snapshot.sh zroot hourly 25",
      require => File["/usr/local/bin/zfs-snapshot.sh"];
    "zfs daily snapshot":
      ensure  => absent,
      user    => root,
      minute  => 0,
      hour    => 0,
      command => "/usr/local/bin/zfs-snapshot.sh zroot daily 8",
      require => File["/usr/local/bin/zfs-snapshot.sh"];
    "zfs weekly snapshot":
      ensure  => absent,
      user    => root,
      minute  => 0,
      hour    => 0,
      weekday => 0,
      command => "/usr/local/bin/zfs-snapshot.sh zroot weekly 5",
      require => File["/usr/local/bin/zfs-snapshot.sh"];
  }

  class { "openvpn::server":
    server => "10.0.44.0 255.255.255.0",
    route  => ["10.0.42.0 255.255.255.0"],
  }

  openvpn::server::csc {
    "baal.puppetlabs.com":
      content => "ifconfig-push 10.0.44.9 10.0.44.10",
  }

}

