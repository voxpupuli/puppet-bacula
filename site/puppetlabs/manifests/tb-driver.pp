class puppetlabs::tb-driver {
  
  include testbed::driver

  ssh::allowgroup { "developers": }
  sudo::allowgroup { "developers": }

}
