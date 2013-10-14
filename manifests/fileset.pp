define bacula::fileset (
    $files,
    $excludes = ''
  ) {

  include bacula

  @@concat::fragment { "bacula-fileset-${name}":
    target  => '/etc/bacula/conf.d/fileset.conf',
    content => template('bacula/fileset.conf.erb'),
    tag     => "bacula-${bacula::params::bacula_director}";
  }
}
