class puppetlabs::tb-driver {
  
  include puppetlabs::lan
  include testbed::driver

  ssh::allowgroup { "developers": }
  sudo::allowgroup { "developers": }

}
