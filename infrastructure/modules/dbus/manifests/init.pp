class dbus {
  package{'dbus':
    notify => Service['dbus'],
  }
  service{'dbus':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
