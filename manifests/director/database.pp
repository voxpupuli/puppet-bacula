class bacula::director::database(
  $make_bacula_tables = '/var/lib/bacula/make_bacula_tables',
  $db_name            = $bacula::director::db_name,
  $db_pw              = $bacula::director::db_pw,
  $db_user            = $bacula::director::db_user,
  $services           = $bacula::params::bacula_director_services,
) inherits bacula::params {

  require postgresql::server

  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_pw),
    encoding => 'SQL_ASCII',
  }

  file { $make_bacula_tables:
    content => template('bacula/make_bacula_postgresql_tables.erb'),
    owner   => 'bacula',
    mode    => '0750',
    before  => Exec["/bin/sh ${make_bacula_tables}"]
  }

  exec { "/bin/sh ${make_bacula_tables}":
    user        => 'bacula',
    refreshonly => true,
    subscribe   => Postgresql::Server::Db[$db_name],
    notify      => Service[$services],
    require     => [
      File[$make_bacula_tables],
      Postgresql::Server::Db[$db_name],
    ]
  }
}
