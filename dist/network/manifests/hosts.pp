class network::hosts{
  file{'/etc/hosts':
    owner => root,
    group => root,
    mode  => 0644,
    ensure => file,
  }
}
