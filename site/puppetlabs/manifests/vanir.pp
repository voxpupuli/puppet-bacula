class puppetlabs::vanir {

  class { "apt-cacher": }
  include puppetlabs::service::bootserver
  class { "nagios": nrpe_server => '173.255.196.32'; }

}

