define users::create($comment, $password, $shell='/bin/bash'){
  include ssh::server
  group{$name:
    ensure => present,
  }
  user {$name:
    groups     => 'sysadmin',
    gid        => $name,
    ensure     => present,
    comment    => $comment,
    home       => "/home/${name}",
    managehome => true,
    password   => $password,
    shell      => $shell,
  }
  File{
    owner    => $name,
    group    => $name,
  }
  line::ensure { "sshd_config_AllowUsers-${title}":
    file    => "/etc/ssh/sshd_config",
    line    => "AllowUsers ${name}",
    pattern => "^AllowUsers ${name}$",
    require => File["sshd_config"],
    notify  => Service['sshd'], 
  }
  file{"/home/${name}/.ssh":
      mode     => '0700',
      ensure   => directory,
  }
  file{"/home/${name}/.ssh/authorized_keys2": ensure => absent}
  file{"/home/${name}/.ssh/authorized_keys": 
    ensure => present,
    mode   => 400,
    source => "puppet:///modules/users/${name}/authorized_keys",
  }
}
