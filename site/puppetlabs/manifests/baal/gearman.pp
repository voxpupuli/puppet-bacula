class puppetlabs::baal::gearman {

  # This class should get replaced with the mod-gearman pacakges that are in wheezy

  file {
    "/etc/apt/sources.list.d/wheezy.list":
      content => "deb http://ftp.us.debian.org/debian/ wheezy main",
      notify  => Exec["apt-get update"]
  }

  class {
    "nagios::gearman":
      server => true,
      key    => hiera("gearman_key")
  }

}

