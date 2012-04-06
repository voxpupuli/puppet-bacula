node net03 {

  include role::server

  # ----------
  # Bind
  # ----------
  class { 'bind':
    customoptions => "check-names master ignore;\nallow-recursion {192.168.100.0/23; 10.0.0.0/16; };\n",
  }

  bind::zone {
    'puppetlabs.lan':
      type         => 'slave',
      masters      => '192.168.100.8';
    '100.168.192.in-addr.arpa':
      type         => 'slave',
      masters      => '192.168.100.8';
    'dc1.puppetlabs.net':
      type         => 'slave',
      masters      => '10.0.1.20';
    '1.0.10.in-addr.arpa':
      type         => 'slave',
      masters      => '10.0.1.20';
    '5.0.10.in-addr.arpa':
      type         => 'slave',
      masters      => '10.0.1.20';
    '42.0.10.in-addr.arpa':
      type         => 'slave',
      masters      => '10.0.1.20';
  }

}
