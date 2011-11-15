node ran {

  include role::server

  include puppetlabs::service::bootserver

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
  apt::source {
    "wheezy.list":
      distribution => "wheezy",
  }

  apt::pin{ '*':
    release  => 'testing',
    priority => '200',
    filename => 'star'
  }

  class {
    "nagios::gearman":
      key           => hiera("gearman_key"),
      nagios_server => hiera("nagios_server")
  }

}
