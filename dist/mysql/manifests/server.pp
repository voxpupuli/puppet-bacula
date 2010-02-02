class mysql::server inherits mysql {
  package {'mysql-server': ensure => installed }
  service { 'mysql':
    ensure=> running,
    enable=> true,
    hasrestart=> true,
    hasstatus => true,
    require => Package['mysql-server'],
  }
}
