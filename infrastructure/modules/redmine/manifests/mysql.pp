#
# this class creates the redmine db, user, and grants priveleges.
# It expects the following params to be set at a higher scope.
#
#   redmine_db
#   redmine_db_user
#   redmine_db_pw
#
class redmine::mysql {
  require mysql::server
  require mysql::ruby
  if ! $redmine_db {
    fail('$redmine_db parameter is required')
  }
  if ! $redmine_db_user {
    fail('$redmine_db_user parameter is required')
  }
  if ! $redmine_db_pw {
    fail('$redmine_db_pw parameter is required')
  }
  database{$redmine_db:
    ensure   => present,
    charset  => 'utf8',
    provider => 'mysql',
  }
  database_user{"${redmine_db_user}@localhost":
    ensure        => present,
    password_hash => mysql_password($redmine_db_pw),
    require       => Database[$redmine_db],
    provider      => 'mysql',
  }
  database_grant{"${redmine_db}@localhost/${redmine_db}":
#    privileges => [ 'alter_priv', 'insert_priv', 'select_priv', 'update_priv' ],
    provider   => 'mysql',
    privileges => all,
  }
}
