# Class: bacula::client
#
# This class installs and configures the File Daemon to backup a client system.
#
# Sample Usage:
#
#   class { 'bacula::client': director => 'mydirector.example.com' }
#
class bacula::client (
  $port                = '9102',
  $listen_address      = $::ipaddress,
  $password            = 'secret',
  $max_concurrent_jobs = '2',
  $packages            = $bacula::params::bacula_client_packages,
  $services            = $bacula::params::bacula_client_services,
  $conf_dir            = $bacula::params::conf_dir,
  $director            = $bacula::params::director,
  $group               = $bacula::params::bacula_group,
  $client_config       = $bacula::params::client_config,
  $client              = $::fqdn,
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

  concat { $client_config:
    owner   => 'root',
    group   => $group,
    mode    => '0640',
    require => Package[$bacula::params::bacula_client_packages],
    notify  => Service[$bacula::params::bacula_client_services],
  }

  concat::fragment { 'bacula-client-header':
    target  => $client_config,
    content => template('bacula/bacula-fd-header.erb'),
  }

  bacula::messages { 'Standard-fd':
    daemon   => 'fd',
    director => "${director} = all, !skipped, !restored",
    append   => '"/var/log/bacula/bacula-fd.log" = all, !skipped',
  }

  # Tell the director about this client config
  @@bacula::director::client { $client:
    port     => $port,
    client   => $client,
    password => $password,
  }
}
