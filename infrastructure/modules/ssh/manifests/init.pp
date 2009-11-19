class ssh{

  file{'/etc/ssh/ssh_config':
    ensure => file,
  }
}
