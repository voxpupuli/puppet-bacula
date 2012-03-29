class sysctl {
  exec { 'reload-sysctl':
    command     => '/sbin/sysctl -p',
    refreshonly => 'true',
  } 
}
