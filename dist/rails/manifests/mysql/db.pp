define rails::mysql::db($db_user, $db_pw, $db_charset = 'utf8', $dir, $host = 'localhost', $grant='all') {
  require mysql::ruby
  include mysql::params
  ::mysql::db{$name:
    db_user => $db_user,
    db_pw => $db_pw,
    db_charset => $db_charset,
    host => $host,
    grant => $grant, 
  }
  rails::db_config{"$dir":
    adapter => 'mysql',
    username => $db_user,
    password => $db_pw,
    database => $name,
    socket => $mysql::params::socket,
  }
}
