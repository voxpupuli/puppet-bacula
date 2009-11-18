class cups::disable {
  service{"cups":
    enable => false,
    ensure => stopped,
  }
}
