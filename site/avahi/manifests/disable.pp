class avahi::disable {
  service{['avahi-daemon', 'avahi-dnsconfd']:
    ensure    => stopped,
    enable    => false,
    # status does not return the correct return code
  }
}
