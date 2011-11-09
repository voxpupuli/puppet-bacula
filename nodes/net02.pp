node 'net02.dc1.puppetlabs.net' {

  include role::server

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

  apt::source {
    "wheezy.list":
      distribution => "wheezy",
  }

  apt::pin{ '*':
    release  => 'testing',
    priority => '200',
    filename => 'star'
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
    '1.0.10.in-addr.arpa':
      type         => 'master',
      source       => 'puppet:///modules/bind/1.0.10.in-addr.arpa.zone',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    '42.0.10.in-addr.arpa':
      type         => 'master',
      source       => 'puppet:///modules/bind/42.0.10.in-addr.arpa.zone',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    'puppetlabs.lan':
      type          => 'forward',
      custom_config => 'forwarders { 192.168.100.83; };';
    '100.168.192.in-addr.arpa':
      type          => 'forward',
      custom_config => 'forwarders { 192.168.100.83; };';
  }

  # Will live at /etc/bind/keys.d/dhcp_updater
  # RFC 2104 says must be hmac-md5 (man nsupdate)
  $ddnskeyname = 'dhcp_updater'
  bind::key { $ddnskeyname:
      algorithm => 'hmac-md5',
      secret    => 'S5acGh2LrqMeuRkFPmXFqw==',
  }

  class { 'dhcp':
    dnsdomain    => [
      'dc1.puppetlabs.net',
      '1.0.10.in-addr.arpa',
      ],
    nameservers  => ['10.0.1.20'],
    ntpservers   => ['us.pool.ntp.org'],
    interfaces   => ['eth0'],
    dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
    require      => Bind::Key[ $ddnskeyname ],
    pxeserver    => '10.0.1.50',
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ 'dc1.puppetlabs.net':
    network => '10.0.42.0',
    mask    => '255.255.255.0',
    range   => '10.0.42.100 10.0.42.200',
    gateway => '10.0.42.1',
  }

  dhcp::pool{ 'ops.dc1.puppetlabs.net':
    network => '10.0.1.0',
    mask    => '255.255.255.0',
    range   => '10.0.1.100 10.0.1.200',
    gateway => '10.0.1.1',
  }

  dhcp::pool{ 'selab.dc1.puppetlabs.net':
    network => '10.0.5.0',
    mask    => '255.255.255.0',
    range   => '10.0.5.50 10.0.5.200',
    gateway => '10.0.5.1',
  }

  dhcp::host {
    'ran':
      mac => "00:50:56:b2:00:ab",
      ip  => "10.0.1.50",
  }

}

