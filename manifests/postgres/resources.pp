class bacula::postgres::resources {
  file { '/var/lib/bacula/postgres':
    ensure  => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }
}

