node enkal {
  include role::server

  ssh::allowgroup { "qa": }

  ssh::allowgroup  { "techops": }
  sudo::allowgroup { "techops": }

  # Base
  include puppetlabs_ssl
  include puppetlabs::docs
  include account::master

  # Having a double slash, eg /etc/ssl//certs/pk.key makes apache asplode.
  # Rather than changing the globally used puppetlabs_ssl variable,
  # changing it here.
  # Fix me after hours when this can be tested without blowing up the world.
  #$ssl_path = $puppetlabs_ssl::params::ssl_path
  $ssl_path = "/etc/ssl"

  # Jenkins
  class { "jenkins":
    site_alias => 'jenkins.puppetlabs.com',
  }

  Account::User <| tag == 'developers' |>
  Group <| tag == 'developers' |>

  openvpn::client {
    "node_${hostname}_office":
      server => "office.puppetlabs.com",
      cert   => "node_${hostname}",
    "node_${hostname}_dc1":
      server => "vpn.puppetlabs.net",
      cert   => "node_${hostname}",
  }


  # DNS resolution to internal hosts
  include unbound
  unbound::stub { "puppetlabs.lan":
    address  => '192.168.100.8',
    insecure => true,
  }

  unbound::stub { "100.168.192.in-addr.arpa.":
    address  => '192.168.100.8',
    insecure => true,
  }

  unbound::stub { "dc1.puppetlabs.net":
    address  => '10.0.1.20',
    insecure => true,
  }

  unbound::stub { "42.0.10.in-addr.arpa.":
    address  => '10.0.1.20',
    insecure => true,
  }


  # zleslie: stop dhclient from updating resolve.conf
  file { "/etc/dhcp3/dhclient-enter-hooks.d/nodnsupdate":
    owner   => root,
    group   => root,
    mode    => 755,
    content => "#!/bin/sh\nmake_resolv_conf(){\n:\n}",
  }

  # Use unbound
  file { "/etc/resolv.conf":
    owner  => root,
    group  => root,
    mode   => 644,
    source => "puppet:///modules/puppetlabs/local_resolv.conf";
  }

}

