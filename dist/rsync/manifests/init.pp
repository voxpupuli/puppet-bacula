class rsync (
    $enable = "true"
  ) {
  #package { "rsync": ensure => installed; }

  file { "/etc/default/rsync":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("rsync/default.erb");
  }

  service { "rsync":
    ensure => $enable ? {
      "true"  => running,
      default => stopped, },
    enable => $enable ? {
      "true"  => true,
      default => false, },
  }

  concat::fragment { 'rsyncd.conf-header':
    order   => '00',
    target  => "/etc/rsyncd.conf",
    content => template("rsync/rsyncd.conf.erb"),
  }

  concat { "/etc/rsyncd.conf": 
    notify => Service["rsync"],
  }

}

