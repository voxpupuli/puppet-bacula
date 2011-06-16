class puppetlabs::service::pkgrepo {

  ###
  # Package repositories
  #
  class { "apt::server::repo": site_name => "apt.puppetlabs.com"; }
  include yumrepo


}

