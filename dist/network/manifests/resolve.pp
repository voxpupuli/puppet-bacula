class network::resolve{
  file{'/etc/resolv.conf':
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("network/resolv.conf.erb")
  }
}
