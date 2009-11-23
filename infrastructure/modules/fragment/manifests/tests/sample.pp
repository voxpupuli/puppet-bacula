# resulting /etc/named.conf will be built by concat'ing the 2 following
# snippets together, order can be specified with the order option

fragment::concat{"/tmp/named.conf":}
fragment{'test1':
  order	    => 00,
  directory => '/tmp/named.conf.d',
  content   => 'test1',
}
# will be created at order 10 by default
fragment{'test2':
  content   =>'test2',
  directory => '/tmp/named.conf.d',
}
