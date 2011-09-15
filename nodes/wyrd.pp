node wyrd {

  include role::server

  file {
    "/etc/apt/sources.list.d/wheezy.list":
      content => "deb http://ftp.us.debian.org/debian/ wheezy main",
      notify  => Exec["apt-get update"]
  }

  class {
    "nagios::gearman":
      key => hiera("gearman_key")
  }

}

