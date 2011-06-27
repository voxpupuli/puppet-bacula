define bacula::fileset (
    $files,
    $excludes = ''
  ) {

  @@concat::fragment {
    "bacula-fileset-$name":
      target  => '/etc/bacula/conf.d/fileset.conf',
      content => template("bacula/fileset.conf.erb"),
      tag     => "bacula-$director";
  }

}

