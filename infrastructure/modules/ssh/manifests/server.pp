class ssh::server  inherits ssh {
  include ssh
  package{'openssh-server':
    ensure  => latest, 
    require => Package['openssh'],
    notify  => Service['sshd'],
  }  
  # not managing the defaults for this file, yet
  file{'sshd_config':
    path    => '/etc/ssh/sshd_config',
    #source  => '/etc/ssh/sshd_config',
    notify  => Service['sshd'],
    require => Package['openssh-server'],
    mode    => 640,
  }
  service{"sshd":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
