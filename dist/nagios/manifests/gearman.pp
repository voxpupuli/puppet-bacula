class nagios::gearman (
    $server = false,
    $key
  ){

  case $server {
    true: {
      $packages = [
        "gearman",
        "gearman-tools",
        "mod-gearman-doc",
        "mod-gearman-module",
        "mod-gearman-tools",
        "mod-gearman-worker"
      ]
    }
    false: {
      $packages = [
        "mod-gearman-worker"
      ]
    }
    default: { }
  }

  package {
    $packages:
      ensure  => installed,
      require => File["/etc/apt/sources.list.d/wheezy.list"];
  }

  user { "nagios":
    shell => "/bin/bash",
  }

  service { "mod-gearman-worker":
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  file { "/etc/mod-gearman/worker.conf":
    replace => false,
    content => template("nagios/worker.conf.erb"),
    notify  => Service["mod-gearman-worker"],
  }

  if $server == true {
    service { "gearman-job-server":
      ensure    => running,
      enable    => true,
      hasstatus => false,
      pattern   => "gearmand",
    }

    file { "/etc/nagios3/gearman.conf":
      replace => false,
      content => template("nagios/gearman.conf.erb"),
      notify  => [Service["mod-gearman-worker"],Service["$::nagios::params::nagios_service"]],
    }
  }

}
