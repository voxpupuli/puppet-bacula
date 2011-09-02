class puppetlabs::baal::gearman {

  # This class should get replaced with the mod-gearman pacakges that are in wheezy

  file {
    "/etc/apt/sources.list.d/wheezy.list":
      content => "deb http://ftp.us.debian.org/debian/ wheezy main"
      notify  => Exec["apt-get update"]
  }

  $packages = [
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
    "libltdl-dev",
    "libncurses5-dev",
    "libevent-dev"
    "gearman"
  ]

  package { $packages: ensure => installed; }

  file { "/etc/ld.so.conf.d/opt_lib.conf":
    ensure  => absent,
    content => "/opt/lib",
    replace => false,
    notify  => Exec["ldconfig"],
  }

  exec { "ldconfig":
    command     => "/sbin/ldconfig",
    user        => root,
    refreshonly => true,
  }

}

