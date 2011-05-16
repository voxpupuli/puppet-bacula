class drbd (
  $usage_count   = "no",
  $protocol      = "C",
  $shared_secret = "8AD8FE98D917AC60D2F9D303FD7485FBF8A2BD468A9B0574663EC6DE268B0A33",
  $rate          = "20M"
  ) {

  package {
    "drbd8-utils": ensure => installed;
  }

  file {
    "/etc/drbd.conf":
      owner   => root,
      group   => root,
      mode    => 644,
      source  => "puppet:///modules/drbd/drbd.conf";
    "/etc/drbd.d":
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => 755,
      recurse => true,
      purge   => true,
      notify  => Service['drbd'];
    "/etc/drbd.d/global_common.conf":
      owner   => root,
      group   => root,
      mode    => 644,
      content => template("drbd/global_common.conf.erb"),
      notify  => Service['drbd'];
  }

  service {
    "drbd":
      ensure    => running,
      enable    => true,
      hasstatus => true,
  }


}

