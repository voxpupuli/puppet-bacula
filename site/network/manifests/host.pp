class network::host{
  file{'/etc/host.conf':
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => 'puppet:///modules/network/host.conf',
  }
}
