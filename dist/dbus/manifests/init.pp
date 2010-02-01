class dbus {
  package{'dbus':
    ensure => installed,
    notify => Service['messagebus'],
  }
  service{'messagebus':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
