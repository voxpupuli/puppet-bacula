#
# this class creates the redmine db, user, and grants priveleges.
# It expects the following params to be set at a higher scope.
#
#   db
#   db_user
#   db_pw
#
define redmine::mysql ($db_user, $db_pw, $db, $db_charset = 'utf8', $db_socket) {
  require mysql::server
  require mysql::ruby
  database{$db:
    ensure   => present,
    charset  => 'utf8',
    provider => 'mysql',
    require  => Class['mysql::server'],
  }
  database_user{"${db_user}@localhost":
    ensure        => present,
    password_hash => mysql_password($db_pw),
    require       => [Database[$db],Class['mysql::server']],
    provider      => 'mysql',
  }
  database_grant{"${db}@localhost/${db}":
#    privileges => [ 'alter_priv', 'insert_priv', 'select_priv', 'update_priv' ],
    provider   => 'mysql',
    privileges => all,
    require  => Class['mysql::server'],
  }
  rails::db_config{$name:
    adapter  => 'mysql',
    username => $db_user,
    password => $db_pw,
    database => $db,
    socket   => $db_socket,
    #require  => Vcsrepo[$name],
    #before   => Exec['session'],
  }
}
