define rails::mysql::db(
    $db_user,
    $db_pw,
    $dir,
    $db_charset = 'utf8',
    $host       = 'localhost',
    $grant      = 'all'
) {

  require mysql::ruby
  include mysql::params

  mysql::db { $name:
    db_user    => $db_user,
    db_pw      => $db_pw,
    db_charset => $db_charset,
    host       => $host,
    grant      => $grant, 
  }

  rails::db_config { "${dir}":
    adapter  => 'mysql',
    database => $name,
    username => $db_user,
    password => $db_pw,
    socket   => $mysql::params::socket,
  }

}
