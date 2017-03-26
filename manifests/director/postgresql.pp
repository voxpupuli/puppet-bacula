# Deploys a postgres database server for hosting the Bacula director database.
#
# @param make_bacula_tables
# @param db_name
# @param db_pw
# @param db_user
#
class bacula::director::postgresql (
  String $make_bacula_tables = '',
  String $db_name            = $bacula::director::db_name,
  String $db_pw              = $bacula::director::db_pw,
  String $db_user            = $bacula::director::db_user,
) {

  include ::bacula

  $services = $::bacula::director::services
  $user     = $::bacula::bacula_user

  if $bacula::director::manage_db {
    require ::postgresql::server
    postgresql::server::db { $db_name:
      user     => $db_user,
      password => postgresql_password($db_user, $db_pw),
      encoding => 'SQL_ASCII',
      locale   => 'C',
      before   => Exec["/bin/sh ${make_bacula_tables}"],
      notify   => Exec["/bin/sh ${make_bacula_tables}"],
    }
  }

  exec { "/bin/sh ${make_bacula_tables}":
    user        => $user,
    refreshonly => true,
    environment => ["db_name=${db_name}"],
    notify      => Service[$services],
  }
}
