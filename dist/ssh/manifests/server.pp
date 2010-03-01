class ssh::server {
  include ssh
  package{'openssh-server':
    ensure => latest, 
    require => Package['openssh-client'],
    notify => Service['ssh'],
  }  
  fragment{'sshd_config-header':
    order => '00',
    path => '/etc/ssh',
    target => 'sshd_config',
    source => 'puppet:///modules/ssh/sshd_config',
  }
  fragment::concat{'sshd_config':
    owner => 'root',
    group => 'root',
    mode => '0640',
    path => '/etc/ssh',
    require => Package['openssh-server'],
    notify => Service['sshd'],
  }
  service{"sshd":
    name => ssh,
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }
}
