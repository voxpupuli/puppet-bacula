class puppetlabs::modi {
  ssh::allowgroup { "techops": }
  sudo::allowgroup { "techops": }
  
  include munin::squid

  include squid
  include squid::cache
  class { "squid::params":
    listen      => "192.168.100.102",
    hostname    => "modi.puppetlabs.lan",
    transparent => "true",
  }
  #      ^
  #    /   \
  #    \   /
  #    |   |
  #    |   |
  #    | 0 |
  #   // ||\\
  #  (( // ||
  #   \\))  \\
  # //||    ))
  # ( ))   //
  #  //   ((
}
