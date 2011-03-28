class puppetlabs::apu {
  include puppetlabs::www
  include puppetlabs::docs
  ssh::allowgroup { "www-data": }
  ssh::allowgroup { "release": }

}
