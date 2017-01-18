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
  String $make_bacula_tables = $facts['osfamily'] ? {
    /(?i-mx:debian)/  => '/usr/share/bacula-director/make_postgresql_tables',
    /(?i-mx:freebsd)/ => '/usr/local/share/bacula/make_postgresql_tables',
    /(?i-mx:openbsd)/ => '/usr/local/libexec/bacula/make_postgresql_tables',
    /(?i-mx:redhat)/  => '/usr/libexec/bacula/make_bacula_tables.postgresql',
    default           => '',
  },
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
    environment => ["db_name=${db_name}"],
    subscribe   => Postgresql::Server::Db[$db_name],
    notify      => Service[$services],
    require     => [
      Postgresql::Server::Db[$db_name],
    ]
  }
}
