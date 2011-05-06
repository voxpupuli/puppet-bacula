class puppetlabs::vanir {

  class { "apt-cacher": service => false; }

  class { "heartbeat":
    nodes => "wyrd vanir",
    network => "ucast eth1 192.168.50.5"
  }

  heartbeat::authkey { "1": key_id => "1"; }

  heartbeat::resource {
    "server01":
      resource => "wyrd IPaddr::192.168.100.15/24/eth2:0";
  }

  class { "drbd": }

  drbd::resource {
    "apt-cache":
      peer_ip   => '192.168.50.5',
      peer      => 'wyrd',
      peer_disk => '/dev/data/_apt-cache',
      ip        => '192.168.50.6',
      device    => '/dev/drbd0',
      disk      => '/dev/vanir/_apt-cache',
      port      => '7790'
  }



}
