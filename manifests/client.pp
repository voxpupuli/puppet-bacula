class bacula::client (
  $port                = '9102',
  $listen_address      = $::ipaddress,
  $password            = 'secret',
  $max_concurrent_jobs = '2',
  $packages            = $bacula::params::bacula_client_packages,
  $services            = $bacula::params::bacula_client_services,
  $conf_dir            = $bacula::params::conf_dir,
  $director            = $bacula::params::bacula_director,
  ) inherits bacula::params {

  include bacula::common
  include bacula::ssl

  package { $packages:
    ensure => present,
  }

  service { $services:
    ensure    => running,
    enable    => true,
    subscribe => File[$bacula::ssl::ssl_files],
    require   => Package[$packages],
  }

  file { $bacula::params::client_config:
    require => Package[$bacula::params::bacula_client_packages],
    content => template('bacula/bacula-fd.conf.erb'),
    notify  => Service[$bacula::params::bacula_client_services],
  }

  # Insert information about this host into the director's config
  @@concat::fragment { "bacula-client-${::fqdn}":
    target  => '/etc/bacula/conf.d/client.conf',
    content => template('bacula/client.conf.erb'),
    tag     => "bacula-${bacula::params::bacula_director}",
  }

  # Realize any virtual jobs that may or may not exist.
  Bacula::Job <||>
}
