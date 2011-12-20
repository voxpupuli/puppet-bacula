# Class: nginx::server
#
#   Install and run the nginx webserver.
#
# Requires:
#
# Debian/ubuntu at present.
#
class nginx::server {
  include nginx

  # We assume for our modules, we have the motd module, & use it.
  motd::register{ 'nginx': }

  package{ 'nginx':
    name   => $nginx::params::package,
    ensure => present,
  }

  service{ 'nginx':
    name       => $nginx::params::service,
    ensure     => running,
    enable     => true,
    hasstatus  => $nginx::params::hasstatus,
    hasrestart => $nginx::params::hasrestart,
    subscribe  => Package['nginx'],
  }


  # All the files, stolen from debian, hence this being debian
  # specific at the minute.
  file { $nginx::params::vdir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

}
