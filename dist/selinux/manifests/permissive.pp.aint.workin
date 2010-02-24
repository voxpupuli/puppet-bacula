class selinux::permissive { 
  file{'/etc/selinux/config':
    content => template('selinux/config.erb'),
  } 
  exec{'setenforce Permissive':
    onlyif => 'getenforce | grep Enforcing',
    path   => '/usr/sbin/',
  }
}
