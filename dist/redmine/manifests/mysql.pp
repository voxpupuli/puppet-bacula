#
# this class creates the redmine db, user, and grants priveleges.
# It expects the following params to be set at a higher scope.
#
#   db
#   db_user
#   db_pw
#
define redmine::mysql ($db_user, $db_pw, $db_charset = 'utf8', $dir) {
  require mysql::server
  require mysql::ruby
  include mysql::params
  database{$name:
    ensure => present,
    charset => $db_charset,
    provider => 'mysql',
    require => Class['mysql::server'],
  }
  database_user{"${db_user}@localhost":
    ensure => present,
    password_hash => mysql_password($db_pw),
    require => Database[$name],
    provider => 'mysql',
  }
  database_grant{"${db_user}@localhost/${name}":
#    privileges => [ 'alter_priv', 'insert_priv', 'select_priv', 'update_priv' ],
    provider => 'mysql',
    privileges => all,
    require => Database_user["${db_user}@localhost"],
  }
  rails::db_config{"$dir":
    adapter => 'mysql',
    username => $db_user,
    password => $db_pw,
    database => $name,
    socket => $mysql::params::socket,
  }
}
