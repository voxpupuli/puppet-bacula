define bacula::job (
    $files    = '',
    $excludes = '',
    $fileset  = ''
  ) {

  if ! defined(Class["bacula"]) {
    err("need class bacula for this to be useful")
  }
  $director = $bacula::bacula_director

  # so if the fileset is not defined, we fall back to one called Common
  if $fileset {
    $fileset_real = "bacula-fileset-$name"
    @@concat::fragment {
      "bacula-fileset-$name":
        target  => '/etc/bacula/conf.d/fileset.conf',
        content => template("bacula/fileset.conf.erb"),
        tag     => "bacula-$director";
    }
  } else {
    $fileset_real = "Common"
  }

  @@concat::fragment {
    "bacula-job-$name":
      target  => '/etc/bacula/conf.d/job.conf',
      content => template("bacula/job.conf.erb"),
      tag     => "bacula-$director";
  }

}

