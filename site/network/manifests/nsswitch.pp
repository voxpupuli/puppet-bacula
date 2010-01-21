class network::nsswitch{
  file{'/etc/nsswitch.conf':
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => 'puppet:///modules/network/nsswitch.conf',
  }
}
