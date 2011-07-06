class mysql::params{
  $socket = '/var/run/mysqld/mysqld.sock'

  $mysql_service_name = $operatingsystem ? {
    ubuntu  => 'mysql',
    debian  => 'mysql',
    darwin  => 'org.mysql.mysqld',
    default => 'mysqld',
  }

}
