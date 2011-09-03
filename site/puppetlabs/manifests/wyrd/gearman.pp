class puppetlabs::wyrd::gearman {

  file {
    "/etc/apt/sources.list.d/wheezy.list":
      content => "deb http://ftp.us.debian.org/debian/ wheezy main",
      notify  => Exec["apt-get update"]
  }

  $packages = [
    "gearman",
    "gearman-tools",
    "mod-gearman-doc",
    "mod-gearman-module",
    "mod-gearman-tools",
    "mod-gearman-worker"
  ]

  package { $packages: ensure => installed; }

  user { "nagios":
    shell => "/bin/bash",
  }


}

