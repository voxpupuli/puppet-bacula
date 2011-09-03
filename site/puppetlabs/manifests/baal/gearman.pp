class puppetlabs::baal::gearman {

  # This class should get replaced with the mod-gearman pacakges that are in wheezy

  file {
    "/etc/apt/sources.list.d/wheezy.list":
      content => "deb http://ftp.us.debian.org/debian/ wheezy main",
      notify  => Exec["apt-get update"]
  }

  $packages = [
    "gearman/testing",
    "mod-gearman-doc/testing",
    "mod-gearman-module/testing",
    "mod-gearman-tools/testing",
    "mod-gearman-worker/testing"
  ]

  package { $packages: ensure => installed; }

  user { "nagios":
    shell => "/bin/bash",
  }

  service { "gearman-job-server":
    ensure    => running,
    enable    => true,
    hasstatus => false,
    pattern   => "gearmand",
  }

  service { "mod-gearman-worker":
    ensure => running,
    enable => true,
  }

  $key = 'FpIHcrKjZrZy2DYzhEMog9OLwAD4KuV'
  file { "/etc/mod-gearman/worker.conf":
    content => template("nagios/worker.conf.erb"),
  }

}

