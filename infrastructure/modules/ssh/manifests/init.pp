class ssh{
  package{'openssh':}
  file{'/etc/ssh/ssh_config':
    ensure  => file,
    require => Package['openssh']
  }
}
