class bacula::openldap::resources {
  file { '/var/lib/bacula/openldap':
    ensure  => directory,
    require => Package[$bacula::params::bacula_client_packages],
  }
}

