class avahi::disable {
  service{"avahi":
    ensure => stopped,
    enable => false,
  }
}
