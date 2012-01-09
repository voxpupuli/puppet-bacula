# Net01 network management node
#
# for things like DNS, DHCP, and friends. 

node net01 {

  include role::server
  include git

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

  # rsyslog hackery.
  file{ '/etc/rsyslog.d/aruba.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_rsyslog_aurba.conf',
  }

  file{ '/etc/rsyslog.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_rsyslog.conf',
  }

  file{ '/etc/logrotate.d/aruba':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_logrotate_aruba',
  }

  service{ 'rsyslog':
    hasstatus  => true,
    hasrestart => true,
    ensure     => running,
    enable     => true,
    subscribe  => [ File['/etc/rsyslog.conf'],
                    File['/etc/rsyslog.d/aruba.conf'] ],
  }

  # DNS Stuff
  class { 'bind':
    customoptions => "check-names master ignore;\nallow-recursion {192.168.100.0/24; 10.0.0.0/16; };\n",
  }

  $ddnskeyname = 'dhcp_updater'
  bind::key { $ddnskeyname:
      algorithm => 'hmac-md5',
      secret    => 'S5acGh2LrqMeuRkFPmXFqw==',
  }

  bind::zone {
    'puppetlabs.lan':
      type         => 'master',
      initialfile  => 'puppet:///modules/bind/puppetlabs.lan.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    '110.168.192.in-addr.arpa':
      type         => 'master',
      initialfile  => 'puppet:///modules/bind/42.0.10.in-addr.arpa.initial',
      allow_update => 'key "dhcp_updater"',
      require      => Bind::Key['dhcp_updater'];
    'dc1.puppetlabs.net':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
    '1.0.10.in-addr.arpa':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
    '5.0.10.in-addr.arpa':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
    '42.0.10.in-addr.arpa':
      type          => 'slave',
      masters       => '10.0.1.20',
      require       => Bind::Key['dhcp_updater'];
  }

  # DHCP
  class { 'dhcp':
    dnsdomain    => [
      'puppetlabs.lan',
      '110.168.192.in-addr.arpa',
      ],
    nameservers  => ['192.168.110.8'],
    ntpservers   => ['us.pool.ntp.org'],
    interfaces   => ['eth1'],
    dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
    require      => Bind::Key[ $ddnskeyname ],
    pxeserver    => '10.0.1.50',
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ 'puppetlabs.lan':
    network => '192.168.110.0',
    mask    => '255.255.255.0',
    range   => '192.168.110.100 192.168.110.200',
    gateway => '192.168.110.1',
  }

}
