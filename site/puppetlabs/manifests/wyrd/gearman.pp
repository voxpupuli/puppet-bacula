class puppetlabs::wyrd::gearman {

  file {
    "/etc/apt/sources.list.d/wheezy.list":
      content => "deb http://ftp.us.debian.org/debian/ wheezy main",
      notify  => Exec["apt-get update"]
  }

  $packages = [
    "mod-gearman-worker"
  ]

  package { $packages: ensure => installed; }

  user { "nagios":
    shell => "/bin/bash",
  }

  service { "mod-gearman-worker":
    ensure => running,
    enable => true,
    hasstatus => true,
  }

  $key = 'FpIHcrKjZrZy2DYzhEMog9OLwAD4KuV'
  file { "/etc/mod-gearman/worker.conf":
    replace => false,
    content => template("nagios/worker.conf.erb"),
    notify  => Service["mod-gearman-worker"],
  }

}

