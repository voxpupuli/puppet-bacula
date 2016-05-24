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
  $make_bacula_tables = "${bacula::params::homedir}/make_bacula_tables",
  $db_name            = $bacula::director::db_name,
  $db_pw              = $bacula::director::db_pw,
  $db_user            = $bacula::director::db_user,
  $services           = $bacula::params::bacula_director_services,
  $user               = $bacula::params::bacula_user,
) inherits bacula::params {

  require postgresql::server

  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_pw),
    encoding => 'SQL_ASCII',
    locale   => 'C',
  }

  # Check if there's a make tables file that comes with the distro.
  case $::operatingsystem {
    'Ubuntu','Debian': {
      $make_bacula_tables_file = '/usr/share/bacula-director/make_postgresql_tables'
    }
    'RedHat','CentOS','Fedora','Scientific': {
      $make_bacula_tables_file = '/usr/libexec/bacula/make_postgresql_tables'
    }

    default: {
      $make_bacula_tables_file = false
      file { $make_bacula_tables:
        content => template('bacula/make_bacula_postgresql_tables.erb'),
        owner   => $user,
        mode    => '0750',
        before  => Exec["/bin/sh ${make_bacula_tables}"]
      }
    }
  }

  exec { "/bin/sh ${make_bacula_tables}":
    user        => $user,
    refreshonly => true,
    subscribe   => Postgresql::Server::Db[$db_name],
    notify      => Service[$services],
    require     => [
      File[$make_bacula_tables],
      Postgresql::Server::Db[$db_name],
    ],
    unless      => "/usr/bin/test -f ${make_bacula_tables_file}",
  }

  exec { "/bin/sh ${make_bacula_tables_file}":
    user        => $user,
    refreshonly => true,
    subscribe   => Postgresql::Server::Db[$db_name],
    notify      => Service[$services],
    require     => Postgresql::Server::Db[$db_name],
    onlyif      => "/usr/bin/test -f ${make_bacula_tables_file}",
  }

}
