class mysql::params{
  $socket = '/var/run/mysqld/mysqld.sock'

  $mysql_service_name = $operatingsystem ? {
    ubuntu  => 'mysql',
    debian  => 'mysql',
    default => 'mysqld',
  }

}
