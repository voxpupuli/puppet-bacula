class ssh{
  package{'openssh-client':
    ensure => latest,
  }
  file{'/etc/ssh/ssh_config':
    owner   => root,
    group   => root,
    mode    => 0644,
    ensure  => file,
    require => Package['openssh-client']
  }
}
