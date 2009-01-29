class mysql::server inherits mysql{
  package {"mysql-server": ensure => installed }  
  service { "mysqld":
    ensure=> running,
    enable=> true,
    hasrestart=> true,
    hasstatus => true,
    require => Package["mysql-server"],
  }
}
