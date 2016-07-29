# Class: bacula::director::postgresql
#
# Deploys a postgres database server for hosting the Bacula director
# database.
#
# Sample Usage:
#
#   none
#
class bacula::director::postgresql(
  String $make_bacula_tables = '',
  String $db_name            = $bacula::director::db_name,
  String $db_pw              = $bacula::director::db_pw,
  String $db_user            = $bacula::director::db_user,
  Array $services            = $bacula::params::bacula_director_services,
  String $user               = $bacula::params::bacula_user,
) inherits bacula::params {

  require postgresql::server

  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_pw),
    encoding => 'SQL_ASCII',
    locale   => 'C',
  }

  exec { "/bin/sh ${make_bacula_tables}":
    user        => $user,
    refreshonly => true,
    subscribe   => Postgresql::Server::Db[$db_name],
    notify      => Service[$services],
    require     => [
      Postgresql::Server::Db[$db_name],
    ]
  }
}
