node 'net02.dc1.puppetlabs.net' {

  include role::server

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

  apt::source {
    "wheezy.list":
      distribution => "wheezy",
  }

  class {
    "nagios::gearman":
      key => hiera("gearman_key")
  }

  class { 'bind':
    customoptions => "check-names master ignore;\nallow-recursion {192.168.100.0/24; 10.0.0.0/16; };\n",
  }

  bind::zone {
    'dc1.puppetlabs.net':
      type         => 'master',
      source       => 'puppet:///modules/bind/dc1.puppetlabs.net.zone',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    '42.0.10.in-addr.arpa':
      type         => 'master',
      source       => 'puppet:///modules/bind/42.0.10.in-addr.arpa.zone',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
  }

  # Will live at /etc/bind/keys.d/dhcp_updater
  $ddnskeyname = 'dhcp_updater'
  bind::key { $ddnskeyname:
      algorithm => 'hmac-sha512',
      secret    => 'LVoHMoAlaPZOK1KusefGWatPQK6zgg==',
  }

  class { 'dhcp':
    dnsdomain    => 'dc1.puppetlabs.net',
    nameservers  => ['10.0.42.1'],
    ntpservers   => ['us.pool.ntp.org'],
    interfaces   => ['eth0'],
    dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
    require      => Bind::Key[ $ddnskeyname ],
  }

  dhcp::pool{ 'dc1.puppetlabs.net':
    network => '10.0.42.0',
    mask    => '255.255.255.0',
    range   => '10.0.42.100 10.0.42.200',
    gateway => '10.0.42.1',
  }

}

