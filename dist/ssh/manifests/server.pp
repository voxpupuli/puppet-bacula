class ssh::server  inherits ssh {
  include ssh
  package{'openssh-server':
    ensure  => latest, 
    require => Package['openssh-client'],
    notify  => Service['sshd'],
  }  
  # not managing the defaults for this file, yet
  fragment{'sshd_config-header':
    order     => '00',
    filename  => '/etc/ssh/sshd_config',
    source    => 'puppet:///modules/ssh/sshd_config',
  }
  fragment::concat{'/etc/ssh/sshd_config':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['openssh-server'],
    notify  => Service['sshd'],
  }
  service{"sshd":
    name       => $operatingsystem? {
      'ubuntu' => 'ssh',
      'debian' => 'ssh',
      'default' => 'sshd', 
    }, 
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
