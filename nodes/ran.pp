node ran {

  include role::server

  include service::bootserver

  nginx::vhost {
    "$fqdn":
      port => 80,
  }

  file { "/var/www/ran.dc1.puppetlabs.net/d-i/debian_base.cfg":
    source => "puppet:///puppetlabs/debian_base.cfg",
  }

  ####
  # Gearman
  #
  class {
    "nagios::gearman":
      key           => hiera("gearman_key"),
      nagios_server => hiera("nagios_server")
  }

}
