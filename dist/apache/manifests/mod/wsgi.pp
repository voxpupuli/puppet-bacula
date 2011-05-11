class apache::mod::wsgi {
  include apache

  package { "wsgi":
    name => $operatingsystem ? {
      centos  => "mod_wsgi",
      default => "libapache",
    },
    ensure  => installed,
    require => Package["httpd"];
  }
  a2mod { "wsgi": ensure => present; }

}

