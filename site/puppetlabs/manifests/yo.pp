class puppetlabs::yo {

  ssh::allowgroup { "interns": }
  sudo::allowgroup { "interns": }

  include puppetlabs::service::mrepo

}
