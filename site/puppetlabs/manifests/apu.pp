class puppetlabs::apu {
  include puppetlabs::www
  include puppetlabs::docs
  ssh::allowgroup { "release": }

}

