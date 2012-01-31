#
# this creates a single mysql db, with one user and grants priveleges
#   db
#   db_user
#   db_pw
#
define mysql::db (
    $db_user,
    $db_pw,
    $db_charset = 'utf8',
    $host       = 'localhost',
    $grant      = 'all',
    $sql        = ''
) {

  # This is a nasty hack.  Basically you should only set the root password for a DB once.  Class parameters will help
  # make this cleaner along with external node tools.
  #
  if defined(Class['mysql::server']) {
    $mysql_server_class = Class['mysql::server'] 
  } else {
    $mysql_server_class = undef
    fail ( 'must include mysql::server class at top level of node definition and set $mysql_root_pw' )
  }

  database { $name:
    ensure   => present,
    charset  => $db_charset,
    provider => 'mysql',
    require  => $mysql_server_class,
  }

  database_user { "${db_user}@${host}":
    ensure        => present,
    password_hash => mysql_password($db_pw),
    provider      => 'mysql',
    require       => Database[$name],
  }

  database_grant { "${db_user}@${host}/${name}":
    privileges => $grant,
    provider   => 'mysql',
    require    => Database_user["${db_user}@${host}"],
  }

  if ($sql) {
    exec { "${name}-import-import":
      command   => "/usr/bin/mysql -u ${db_user} -p${db_pw} -h ${host} ${name} < ${sql}",
      logoutput => true,
      require   => Database_grant["${db_user}@${host}/${name}"],
    }
  }

  if defined(Class['bacula']) {
    bacula::mysql { $db: }
  }

}
