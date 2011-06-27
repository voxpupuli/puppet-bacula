define bacula::job (
    $files,
    $excludes = ''
  ) {

  @@concat::fragment {
    "$name":
      target  => '/etc/bacula/conf.d/fileset.conf',
      content => template("bacula/fileset.conf.erb"),
      tag     => "bacula-$director";
  }

}

