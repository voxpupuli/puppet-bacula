node faro {
  include role::base

  # DNS resolution to internal hosts
  class {
    "unbound":
      interface => ["::0","0.0.0.0"],
      access    => ["192.168.100.0/23","192.168.124.0/24","10.0.0.0/16"],
  }

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


}
