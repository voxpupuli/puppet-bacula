class puppetlabs::baal::gearman {

  # This class should get replaced with the mod-gearman pacakges that are in wheezy

  file {
    "/etc/apt/sources.list.d/wheezy.list":
      content => "deb http://ftp.us.debian.org/debian/ wheezy main",
      notify  => Exec["apt-get update"]
  }

  $packages = [
    "gearman",
    "mod-gearman-doc"
    "mod-gearman-module",
    "mod-gearman-tools",
    "mod-gearman-worker"
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

