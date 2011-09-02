class puppetlabs::modi {
  ssh::allowgroup { "techops": }
  sudo::allowgroup { "techops": }
  
  class { "squid::params":
    listen      => "192.168.100.102",
    hostname    => "modi.puppetlabs.lan",
    transparent => "true",
  }

  include squid
  include squid::cache
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
