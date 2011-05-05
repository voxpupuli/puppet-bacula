class puppetlabs::wyrd {

  class { "apt-cacher": service => false; }

  # keeps http://wyrd.puppetlabs.lan/puppetdoc/ up to date
  cron {
    "pull ~zach/src/puppetlabs-modules":
      command => "source ~/.keychain/wyrd.sh && (cd ~zach/src/puppetlabs-modules/; git pull)",
      user => zach,  minute => '*/10';
  }

  apache::vhost {
    "wyrd.puppetlabs.lan":
      port    => 80,
      docroot => '/opt/www'
  }

  class { "heartbeat":
    nodes => "wyrd vanir",
    network => "ucast eth1 192.168.50.6"
  }

  heartbeat::authkey { "1": key_id => "1"; }

  heartbeat::resource {
    "server01":
      resource => "wyrd IPaddr::192.168.100.15/24/eth0:0";
  }

  class { "drbd": }

  drbd::resource {
    "apt-cache":
      peer_ip   => '192.168.50.6',
      peer      => 'vanir',
      peer_disk => '/dev/vanir/_apt-cache',
      device    => '/dev/drbd0',
      disk      => '/dev/data/_apt-cache',
      port      => '7790'
  }



}

