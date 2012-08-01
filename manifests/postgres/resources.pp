class bacula::postgres::resources {

  # Let postgres user write to this dir, as it's going to be doing the
  # backups in the first place.

  file { '/var/lib/bacula/postgres':
    ensure  => directory,
    mode    => '0700',
    owner   => 'root',
    require => Package[$bacula::params::bacula_client_packages],
  }
}

