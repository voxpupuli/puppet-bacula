class role::gearman {

  class {
    "nagios::gearman":
      key           => hiera("gearman_key"),
      nagios_server => hiera("nagios_server"),
  }

  apt::source { "ops_lan.list":
    uri    => "http://pkgs.puppetlabs.lan",
    before => Class["nagios::gearman"],
  }

  exec { "import pluto apt key":
    user    => root,
    alias   => "pluto_key",
    command => "/usr/bin/wget -q -O - http://pkgs.puppetlabs.lan/pubkey.gpg | apt-key add -",
    unless  => "/usr/bin/apt-key list | grep -q 27D8D6F1",
    before  => Exec["apt-get update"];
  }

}
