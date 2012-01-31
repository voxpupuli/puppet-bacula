#
# right now, this only works for mysql
#
define rails::db_config(
    $adapter,
    $database,
    $username,
    $password,
    $host        = 'localhost',
    $encoding    = 'utf8',
    $environment = 'production',
    $socket      = '/tmp/mysql.sock'
){
  file { "${name}/config/database.yml":
    content => template('rails/database.yml.erb'),
  }
}
