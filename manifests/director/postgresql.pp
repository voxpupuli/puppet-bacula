# @summary Manage Bacula Director PostgreSQL database
#
# Deploys a postgres database server for hosting the Bacula director database.
#
# @param make_bacula_tables Path to the script that loads the database schema
# @param db_name            The database name
# @param db_pw              The database user's password
# @param db_user            The database user
#
class bacula::director::postgresql (
  String           $make_bacula_tables = $bacula::director::make_bacula_tables,
  String           $db_name            = $bacula::director::db_name,
  Bacula::Password $db_pw              = $bacula::director::db_pw,
  String           $db_user            = $bacula::director::db_user,
) {
  include bacula

  $services = $bacula::director::services
  $user     = $bacula::bacula_user

  if $bacula::director::manage_db {
    require postgresql::server
    postgresql::server::db { $db_name:
      user     => $db_user,
      password => postgresql::postgresql_password($db_user, $db_pw),
      encoding => 'SQL_ASCII',
      locale   => 'C',
      before   => Exec['make_bacula_tables'],
      notify   => Exec['make_bacula_tables'],
    }
  }

  exec { 'make_bacula_tables':
    command     => ['/bin/sh', $make_bacula_tables],
    user        => $user,
    refreshonly => true,
    environment => ["db_name=${db_name}"],
    notify      => Service[$services],
  }
}
