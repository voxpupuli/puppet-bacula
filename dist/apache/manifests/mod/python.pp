class apache::mod::python {
  require apache

  package { "python":
    name => $operatingsystem ? {
      centos  => "mod_python",
      default => "libapache2-mod-python",
    },
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "python": ensure => present; }

}


