# @summary Configure the Bacula File Daemon
#
# This class installs and configures the File Daemon to backup a client system.
#
# @param messages            Logging configuration; loaded from hiera
# @param packages            A list of packages to install; loaded from hiera
# @param ensure              What state the package should be in.
# @param services            A list of services to operate; loaded from hiera
# @param default_pool        The name of the Pool for this FD to use by default
# @param default_pool_full   The name of the Pool to use for Full jobs
# @param default_pool_inc    The name of the Pool to use for Incremental jobs
# @param default_pool_diff   The name of the Pool to use for Differential jobs
# @param port                The listening port for the File Daemon
# @param listen_address      The listening IP addresses for the File Daemon
#   By default, Bacula listen an all IPv4 only, which is equivalent to
#   ```
#      listen_address => [
#        '0.0.0.0',
#      ],
#   ```
#   Listening on both IPv6 and IPv4 depends on your system configuration of
#   IPv4-mapped IPv6 (RFC 3493): when enabled, the following is enough to
#   listen on both all IPv6 and all IPv4:
#   ```
#      listen_address => [
#        '::',
#      ],
#   ```
#   If IPv4-mapped IPv6 is not used, each address must be indicated separately:
#   ```
#      listen_address => [
#        '::',
#        '0.0.0.0',
#      ],
#   ```
#   Indicating both addresses with IPv4-mapped IPv6 enabled will result in
#   Bacula being unable to bind twice to the IPv4 address and fail to start.
# @param password            A password to use for communication with this File Daemon
# @param max_concurrent_jobs Bacula FD option for 'Maximum Concurrent Jobs'
# @param director_name       The hostname of the director for this FD
# @param autoprune           Bacula FD option for 'AutoPrune'
# @param file_retention      Bacula FD option for 'File Retention'
# @param job_retention       Bacula FD option for 'Job Retention'
# @param client              The name or address by which to contact this FD
# @param address             The listening address for the File Daemon
# @param pki_signatures      Bacula FD option for 'PKI Signatures'
# @param pki_encryption      Bacula FD option for 'PKI Encryption'
# @param pki_keypair         Bacula FD option for 'PKI Keypair'
# @param pki_master_key      Bacula FD option for 'PKI Master Key'
# @param plugin_dir          Bacula FD option for the 'Plugin Directory'
#
# @example
#   class { 'bacula::client': director_name => 'mydirector.example.com' }
#
class bacula::client (
  Hash[String, Bacula::Message]  $messages,
  Array[String[1]]               $packages,
  String[1]                      $services,
  String[1]                      $default_pool,
  Optional[String[1]]            $default_pool_full,
  Optional[String[1]]            $default_pool_inc,
  Optional[String[1]]            $default_pool_diff,
  String[1]                      $ensure              = 'present',
  Stdlib::Port                   $port                = 9102,
  Array[String[1]]               $listen_address      = [],
  Bacula::Password               $password            = 'secret',
  Integer[1]                     $max_concurrent_jobs = 2,
  String[1]                      $director_name       = $bacula::director_name,
  Bacula::Yesno                  $autoprune           = true,
  Bacula::Time                   $file_retention      = '45 days',
  Bacula::Time                   $job_retention       = '6 months',
  String[1]                      $client              = $trusted['certname'],
  String[1]                      $address             = $facts['networking']['fqdn'],
  Optional[Bacula::Yesno]        $pki_signatures      = undef,
  Optional[Bacula::Yesno]        $pki_encryption      = undef,
  Optional[Stdlib::Absolutepath] $pki_keypair         = undef,
  Optional[Stdlib::Absolutepath] $pki_master_key      = undef,
  Optional[Stdlib::Absolutepath] $plugin_dir          = undef,
) inherits bacula {
  $group    = $bacula::bacula_group
  $conf_dir = $bacula::conf_dir
  $config_file = "${conf_dir}/bacula-fd.conf"

  package { $packages:
    ensure => $ensure,
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
    content => epp('bacula/bacula-fd-header.epp'),
  }

  create_resources(bacula::messages, $messages)
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
