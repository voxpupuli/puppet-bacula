class hal::disable {
  service{"haldaemon":
    ensure => stopped,
    enable => false,
  }
}
