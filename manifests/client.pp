# This class installs and configures the File Daemon to backup a client system.
#
# @param port The listening port for the File Daemon
# @param listen_address The listening INET or INET6 address for File Daemon
# @param password A password to use for communication with this File Daemon
# @param max_concurrent_jobs Bacula FD option for 'Maximum Concurrent Jobs'
# @param packages A list of packages to install; loaded from hiera
# @param services A list of services to operate; loaded from hiera
# @param director_name The hostname of the director for this FD
# @param autoprune Bacula FD option for 'AutoPrune'
# @param file_retention Bacula FD option for 'File Retention'
# @param job_retention Bacula FD option for 'Job Retention'
# @param client The name or address by which to contact this FD
# @param default_pool The name of the Pool for this FD to use by default
# @param default_pool_full The name of the Pool to use for Full jobs
# @param default_pool_inc The name of the Pool to use for Incremental jobs
# @param default_pool_diff The name of the Pool to use for Differential jobs
#
# @example
#   class { 'bacula::client': director_name => 'mydirector.example.com' }
#
class bacula::client (
  String $packages,
  String $services,
  String $default_pool,
  Optional[String] $default_pool_full,
  Optional[String] $default_pool_inc,
  Optional[String] $default_pool_diff,
  String $port         = '9102',
  $listen_address      = $facts['ipaddress'],
  $password            = 'secret',
  $max_concurrent_jobs = '2',
  $director_name       = $bacula::director_name,
  $autoprune           = 'yes',
  $file_retention      = '45 days',
  $job_retention       = '6 months',
  $client              = $trusted['certname'],
  $address             = $facts['fqdn'],
  Optional[Boolean] $pki_signatures = undef,
  Optional[Boolean] $pki_encryption = undef,
  Optional[String]  $pki_keypair    = undef,
  Optional[String]  $pki_master_key = undef,
) inherits bacula {

  $group    = $::bacula::bacula_group
  $conf_dir = $::bacula::conf_dir
  $config_file = "${conf_dir}/bacula-fd.conf"

  package { $packages:
    ensure => present,
  }

  service { $services:
    ensure  => running,
    enable  => true,
    require => Package[$packages],
  }

  $use_pki = ($pki_signatures or $pki_encryption) and $pki_keypair

  concat { $config_file:
    owner     => 'root',
    group     => $group,
    mode      => '0640',
    show_diff => false,
    require   => Package[$packages],
    notify    => Service[$services],
  }

  concat::fragment { 'bacula-client-header':
    target  => $config_file,
    content => template('bacula/bacula-fd-header.erb'),
  }

  bacula::messages { 'Standard-fd':
    daemon   => 'fd',
    director => "${director_name}-dir = all, !skipped, !restored",
    append   => '"/var/log/bacula/bacula-fd.log" = all, !skipped',
  }

  # Tell the director about this client config
  @@bacula::director::client { $client:
    address        => $address,
    port           => $port,
    password       => $password,
    autoprune      => $autoprune,
    file_retention => $file_retention,
    job_retention  => $job_retention,
    tag            => "bacula-${director_name}",
  }
}
