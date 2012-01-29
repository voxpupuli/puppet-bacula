node 'net02.dc1.puppetlabs.net' {

  include role::server

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

  apt::source {
    "wheezy.list":
      distribution => "wheezy",
  }

  apt::pin{ 'wheey_repo_pin':
    release  => 'testing',
    priority => '200',
    filename => 'testingforgearman',
    wildcard => true
  }

  class {
    "nagios::gearman":
      key           => hiera("gearman_key"),
      nagios_server => hiera("nagios_server")
  }

  class { 'bind':
    customoptions => "check-names master ignore;\nallow-recursion {192.168.100.0/23; 10.0.0.0/16; };\n",
  }

  bind::zone {
    'dc1.puppetlabs.net':
      type         => 'master',
      #source       => 'puppet:///modules/bind/dc1.puppetlabs.net.zone',
      initialfile  => 'puppet:///modules/bind/dc1.puppetlabs.net.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    '1.0.10.in-addr.arpa':
      type         => 'master',
      #source       => 'puppet:///modules/bind/1.0.10.in-addr.arpa.zone',
      initialfile  => 'puppet:///modules/bind/1.0.10.in-addr.arpa.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    '5.0.10.in-addr.arpa':
      type         => 'master',
      initialfile  => 'puppet:///modules/bind/5.0.10.in-addr.arpa.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    '42.0.10.in-addr.arpa':
      type         => 'master',
      #source       => 'puppet:///modules/bind/42.0.10.in-addr.arpa.zone',
      initialfile  => 'puppet:///modules/bind/42.0.10.in-addr.arpa.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    'puppetlabs.lan':
      type          => 'slave',
      masters       => '192.168.100.8',
      require       => Bind::Key['dhcp_updater'];
    '100.168.192.in-addr.arpa':
      type          => 'forward',
      masters       => '192.168.100.8',
      require       => Bind::Key['dhcp_updater'];
  }

  include git
  include bind::params

  exec { "ensure dns-zone repo exists":
    path    => ["/usr/bin", "/usr/local/bin"],
    command => "git clone git@git.puppetlabs.net:puppetlabs-dnszones.git /opt/dns",
    creates => "/opt/dns/.git",
  }

  cron { "update dns zones":
    command => "(cd /opt/dns &&  git pull --quiet origin master && /opt/dns/zonedump.rb ${::domain}.ns | /usr/bin/nsupdate -v -k /etc/bind/keys.d/dhcp_updater) ",
    minute  => "*/5",
    user    => "root",
    require => Exec["ensure dns-zone repo exists"],
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
