class ssh{
  package{'openssh-client':
    ensure => latest,
  }
  file{'/etc/ssh/ssh_config':
    owner   => root,
    group   => root,
<<<<<<< HEAD:dist/ssh/manifests/init.pp
    mode    => 0644,
=======
    mode    => 0664,
>>>>>>> 5f9ac9a1f18b54cf5b8f03dbe0515d69134e5085:dist/ssh/manifests/init.pp
    ensure  => file,
    require => Package['openssh-client']
  }
}
