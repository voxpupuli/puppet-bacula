class mysql::params{

  case $operatingsystem {
    'debian','ubuntu': {
      $socket             = '/var/run/mysqld/mysqld.sock'
      $mysql_service_name = 'mysql'
    }
    'darwin': {
      $socket             = '/var/run/mysqld/mysqld.sock'
      $mysql_service_name = 'org.mysql.mysqld'
    }
    default: {
      $socket             = '/var/run/mysqld/mysqld.sock'
      $mysql_service_name = 'mysqld'
    }
  }

}
