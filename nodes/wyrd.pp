node wyrd {

  include role::server

  apt::source {
    "wheezy.list":
      distribution => "wheezy",
  }

  class {
    "nagios::gearman":
      key => hiera("gearman_key")
  }

}

