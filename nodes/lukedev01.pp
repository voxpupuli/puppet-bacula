node lukedev01 {
  include role::server

  sudo::entry{ "luke": entry => "luke ALL=(ALL) NOPASSWD: ALL\n", }

}
