class puppetlabs::burji {

  ssh::allowgroup { "release": }
  sudo::allowgroup { "release": }

  include puppetlabs::service::pkgrepo

}
