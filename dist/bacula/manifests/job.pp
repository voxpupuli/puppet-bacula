define bacula::job (
    $files,
    $excludes = ''
  ) {

  if ! defined(Class["bacula"]) {
    err("need class bacula for this to be useful")
  }
  $director = $bacula::bacula_director

  @@concat::fragment {
    "$name":
      target  => '/etc/bacula/conf.d/fileset.conf',
      content => template("bacula/fileset.conf.erb"),
      tag     => "bacula-$director";
  }

}

