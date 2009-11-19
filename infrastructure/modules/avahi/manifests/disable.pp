class avahi::disable {
  service{['avahi-daemon', 'avahi-dnsconfd']:
    ensure    => stopped,
    enable    => false,
  }
}
