# This is our wonderfully named DC1 firewall.
# It runs FreeBSD so we don't want it including too much for now, or
# trying to do anything too smart.

node 'dave.dc1.puppetlabs.net' {
  include role::server
  include munin::pf

  class{ 'ipsec':
    my_ip         => $::ipaddress,
    their_ip      => '74.85.255.4',
    local_subnet  => '10.0.0.0/16',
    remote_subnet => '192.168.100.0/23',
    local_router  => '10.0.42.1',
    remote_router => '192.168.100.1',
    key           => 'SacyimejhabNedinyootLeOtnemgionobfudolcodNaulufcaupAgDeumsisyicUthCopDur'
  }


  class { "openvpn::server":
    server => "10.0.44.0 255.255.255.0",
    route  => [
      "10.0.42.0 255.255.255.0",
      "10.0.1.0 255.255.255.0",
      "10.0.5.0 255.255.255.0",
      "10.0.10.0 255.255.255.0",
      ],
    dns => '10.0.1.20',
  }

  openvpn::server::csc {
    "baal.puppetlabs.com":
      content => "ifconfig-push 10.0.44.9 10.0.44.10",
  }

}

