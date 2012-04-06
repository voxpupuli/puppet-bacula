class apache::mod::wsgi {
  require apache

  package { "wsgi":
    name => $operatingsystem ? {
      centos  => "mod_wsgi",
      default => "libapache2-mod-wsgi",
    },
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "wsgi": ensure => present; }

}

