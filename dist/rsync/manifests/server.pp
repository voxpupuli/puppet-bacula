define rsync::server (
    $comment,
    $path,
    $exclude = ''
  ) {

  include rsync 

  concat::fragment { "rsyncd.conf-$name":
    target  => "/etc/rsyncd.conf",
    content => template("rsync/rsyncd.conf-entry.erb"),
  }

}

