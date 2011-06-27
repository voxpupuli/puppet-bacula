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

  @@concat::fragment {
    "bacula-job-$hostname":
      target  => '/etc/bacula/conf.d/job.conf',
      content => template("bacula/job.conf.erb"),
      tag     => "bacula-$director";
  }

}

