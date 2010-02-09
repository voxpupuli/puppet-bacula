define rails::db_config(
  $adapter='mysql',
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
