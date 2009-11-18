class motd {
  file{'/etc/motd':
    source => 'puppet:///motd/motd',
  }
}
