# resulting /etc/named.conf will be built by concat'ing the 2 following
# snippets together, order can be specified with the order option

fragment::concat{"/tmp/test.txt":}

fragment{'test1':
  order	   => 00,
  filename => '/tmp/test.txt',
  content  => "test1\n",
}
# will be created at order 10 by default
#fragment{'test2':
#  content   =>'test2',
#  directory => '/tmp/test.d',
#}

#fragment{'test3':
#  content   =>"test3\n",
#  filename => '/tmp/test.txt',
#}
fragment{'test4':
  content   =>"test4\n",
  filename => 'test.txt',
}
