class puppetlabs::vanir {

  class { "apt-cacher": }
  include puppetlabs::service::bootserver

}

