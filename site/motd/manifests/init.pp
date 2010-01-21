class motd {
  file{'/etc/motd':
    source => 'puppet:///modules/motd/motd',
  }
}
