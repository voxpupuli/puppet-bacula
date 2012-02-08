# = Node: modi
#
# == Description
#
# modi provides an caching proxy for the office puppetlabs.lan network.
# it listens on http://modi.puppetlabs.lan:3128
node modi {
  include role::server

  ssh::allowgroup { "techops": }
  sudo::allowgroup { "techops": }

  include service::bootserver

  class { "squid::params":
    listen      => "192.168.100.102",
    hostname    => "modi.puppetlabs.lan",
    transparent => "true",
  }
  include squid
  include squid::cache
  include munin::squid
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
