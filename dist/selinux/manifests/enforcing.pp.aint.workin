class selinux::enforcing { 
  file{'/etc/selinux/config':
    content => template('selinux/config.erb'),
  } 
  exec{'setenforce Enforcing':
    unless => '/usr/sbin/getenforce | grep Enforcing',
    path   => '/usr/sbin/',
  }
}
