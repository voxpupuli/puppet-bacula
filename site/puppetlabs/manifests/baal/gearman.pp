class puppetlabs::baal::gearman {

  # This should get replaced with the mod-gearman pacakges that are in wheezy

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
  ]

  package { $packages: ensure => installed; }

  file { "/etc/ld.so.conf.d/opt_lib.conf":
    content  => "/opt/lib",
    replace  => false,
    notify   => Exec["ldconfig"],
  }

  exec { "ldconfig":
    command     => "/sbin/ldconfig",
    user        => root,
    refreshonly => true,
  }

  exec { "wget mod_gearman":
    command => "wget http://labs.consol.de/wp-content/uploads/2010/09/mod_gearman-1.0.10.tar.gz",
    user    => root,
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/mod_gearman-1.0.10.tar.gz",
  }

}

