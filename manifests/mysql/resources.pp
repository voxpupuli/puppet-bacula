class bacula::mysql::resources {
  file { '/var/lib/bacula/mysql':
    ensure  => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }
}

