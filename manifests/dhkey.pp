class bacula::dhkey {

  exec { 'make dhkey bacula':
    command => 'openssl dhparam -out dh1024.pem -5 1024',
    cwd     => '/etc/bacula/ssl',
    creates => '/etc/bacula/ssl/dh1024.pem',
    require => File['/etc/bacula/ssl'],
  }
}
