node enkal {
  include role::server

  ssh::allowgroup { "qa": }

  ssh::allowgroup  { "techops": }
  sudo::allowgroup { "techops": }

  $mysql_root_pw = 'c@11-m3-m1st3r-p1t4ul'

  # Base
  include puppetlabs_ssl
  include puppetlabs::docs
  include account::master
  $ssl_path = $puppetlabs_ssl::params::ssl_path

  # Backup
  $bacula_director = 'baal.puppetlabs.com'
  class { "bacula":
    director => $bacula_director,
    password => hiera('bacula_password'),
  }

  # Jenkins
  class { "jenkins":
    site_alias => 'jenkins.puppetlabs.com',
  }

  Account::User <| tag == 'developers' |>
  Group <| tag == 'developers' |>

  openvpn::client {
    "node_$hostname":
      server => "office.puppetlabs.com",
  }

  include unbound
  unbound::stub { "puppetlabs.lan": address => '192.168.100.1' }

  # zleslie: stop dhclient from updating resolve.conf
  file { "/etc/dhcp3/dhclient-enter-hooks.d/nodnsupdate":
    owner   => root,
    group   => root,
    mode    => 755,
    content => "#!/bin/sh\nmake_resolv_conf(){\n:\n}",
  }

  # Use unbound
  file { "/etc/resolv.conf":
    owner  => root,
    group  => root,
    mode   => 644,
    source => "puppet:///modules/puppetlabs/local_resolv.conf";
  }

}

