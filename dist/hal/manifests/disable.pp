class hal::disable {
  service{"haldaemon":
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }
}
