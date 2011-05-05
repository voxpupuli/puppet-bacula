class puppetlabs::vanir {

  class { "apt-cacher": service => false; }

  class { "heartbeat":
    nodes => "wyrd vanir",
    network => "ucast eth1 192.168.50.5"
  }

  heartbeat::authkey { "1": key_id => "1"; }

  heartbeat::resource {
    "server01":
      resource => "wyrd IPaddr::192.168.100.15/24/eth0:0";
  }


}
