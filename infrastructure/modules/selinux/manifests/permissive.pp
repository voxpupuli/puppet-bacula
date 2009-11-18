class selinux::permissive { 
  file{'/etc/selinux/config':
    content => template('selinux/config'),
  } 
  exec{'setenforce Permissive':
    onlyif 'selinuxenabled',
  }
}
