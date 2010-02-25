<<<<<<< HEAD:dist/ssh/manifests/server.pp
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
=======
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
>>>>>>> 5f9ac9a1f18b54cf5b8f03dbe0515d69134e5085:dist/ssh/manifests/server.pp
    hasrestart => true,
  }
}
