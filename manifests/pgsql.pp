class bacula::pgsql {

  $make_bacula_tables = '/var/lib/bacula/make_bacula_tables'
  $db_name            = $bacula::director::db_name
  $db_pw              = $bacula::director::db_pw
  $db_user            = $bacula::director::db_user

  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_pw),
    encoding => 'SQL_ASCII',
    require  => Class['postgresql::server'],
    before   => File[$make_bacula_tables]
  }

  file { $make_bacula_tables:
    content => template('bacula/make_bacula_postgresql_tables.erb'),
    owner   => 'bacula',
    mode    => '0777',
    before  => Exec["/bin/sh $make_bacula_tables"]
  }

  exec { "/bin/sh $make_bacula_tables":
    user        => 'bacula',
    refreshonly => true,
    subscribe   => Postgresql::Server::Db[$db_name],
    notify      => Service[bacula-director],
    require     => File[$make_bacula_tables]
  }
}
