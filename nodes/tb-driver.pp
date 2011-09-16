node tb-driver {
  include role::server

  include testbed::driver

  ssh::allowgroup { "developers": }
  sudo::allowgroup { "developers": }

}
