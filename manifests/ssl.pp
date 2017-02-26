# Manage the SSL deployment for bacula components, Director, Storage, and File
# daemons.
#
# @param certfile
# @param keyfile
# @param cafile
# @param packages
#
# @example
#   include bacula::ssl

#bacula::ssl {
#  certfile_source => '/etc/dehydrated/certfile.pem',
#  keyfile_source  => '/etc/dehydrated/keyfile.pem',
#  cafile_source   => '/etc/dehydrated/cafile.pem',
#}
#
# @example in hiera
#   TODO
#
# TODO make DH key length configurable
#
class bacula::ssl (
  #Optional[String] $certfile = undef,
  #Optional[String] $keyfile  = undef,
  #Optional[String] $cafile   = undef,
  #Array $packages            = [],
  String $ssl_dir,
) {

  include ::bacula
  include ::bacula::client

  $conf_dir     = $::bacula::conf_dir
  $bacula_user  = $::bacula::bacula_user
  $bacula_group = $::bacula::bacula_group

  $certfile = "${conf_dir}/ssl/${trusted['certname']}_cert.pem"
  $keyfile  = "${conf_dir}/ssl/${trusted['certname']}_key.pem"
  $cafile   = "${conf_dir}/ssl/ca.pem"

  $ssl_files = [
    $certfile,
    $keyfile,
    $cafile,
  ]

  File {
    owner   => $bacula_user,
    group   => '0',
    mode    => '0640',
    require => Package[$bacula::client::packages],
  }

  file { "${conf_dir}/ssl":
    ensure  => 'directory',
    require => File[$conf_dir],
  }

  file { $certfile:
    source  => "${ssl_dir}/certs/${trusted['certname']}.pem",
    require => File["${conf_dir}/ssl"],
  }

  file { $keyfile:
    source  => "${ssl_dir}/private_keys/${trusted['certname']}.pem",
    require => File["${conf_dir}/ssl"],
  }

  file { $cafile:
    ensure  => 'file',
    source  => "${ssl_dir}/certs/ca.pem",
    require => File["${conf_dir}/ssl"],
  }

  exec { 'generate_bacula_dhkey':
    command => 'openssl dhparam -out dh2048.pem -5 2048',
    path    => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    cwd     => "${conf_dir}/ssl",
    creates => "${conf_dir}/ssl/dh2048.pem",
    timeout => '1800',
    require => File["${conf_dir}/ssl"],
  }
}
