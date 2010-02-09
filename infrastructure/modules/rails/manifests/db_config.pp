#
# right now, this only works for mysql
#
define rails::db_config(
  $adapter,
  $database,
  $host='localhost',
  $username,
  $password,
  $encoding='utf8',
  $environment='production'
){
  file{"${name}/config/database.yml":
    content => template('rails/database.yml.erb'),
  }
}
