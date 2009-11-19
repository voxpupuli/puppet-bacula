define sysadmin_create($comment, $password, $shell='/bin/bash'){
  group{$name:
    ensure => present,
  }
  user {"${name}":
    groups     => 'sysadmin',
    ensure     => present,
    comment    => ${comment},
    home       => "/home/${name}",
    managehome => true,
    password   => ${password},
    shell      => ${shell},
  }
  file{"/home/${name}/.ssh":
      owner    => ${name},
      group    => ${name},
      mode     => '0700',
      ensure   => directory,
  }
  file{"/home/${name}/.ssh/authorized_keys2": ensure => absent}
  file{"/home/${name}/.ssh/authorized_keys": 
    ensure => present,
    mode   => 400,
    source => "puppet:///accounts/${name}/authorized_keys.conf",
  }
}
