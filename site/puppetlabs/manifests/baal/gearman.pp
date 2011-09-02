class puppetlabs::baal::gearman {

  packages = [
    "autoconf",
    "automake",
    "make",
    "gcc",
    "g++",
    "wget",
    "tar",
    "file",
    "netcat",
    "uuid-dev",
    "libltdl3-dev",
    "libncurses5-dev",
    "libevent-dev",
  ]

  package { $packages: ensure => installed; }

}

