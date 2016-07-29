# Class: bacula::director
#
# This class installs and configures the Bacula Backup Director
#
# Parameters:
# * db_user: the database user
# * db_pw: the database user's password
# * db_name: the database name
# * password: password to connect to the director
#
# Sample Usage:
#
#   class { 'bacula::director':
#     storage => 'mystorage.example.com'
#   }
#
class bacula::director (
  $port                = '9101',
  $listen_address      = $::ipaddress,
  $db_user             = $bacula::params::bacula_user,
  $db_pw               = 'notverysecret',
  $db_name             = $bacula::params::bacula_user,
  $db_type             = $bacula::params::db_type,
  $password            = 'secret',
  $max_concurrent_jobs = '20',
  $packages            = $bacula::params::bacula_director_packages,
  $services            = $bacula::params::bacula_director_services,
  $homedir             = $bacula::params::homedir,
  $rundir              = $bacula::params::rundir,
  $conf_dir            = $bacula::params::conf_dir,
  $director            = $::fqdn, # director here is not params::director
  $director_address    = $bacula::params::director_address,
  $storage             = $bacula::params::storage,
  $group               = $bacula::params::bacula_group,
  $job_tag             = $bacula::params::job_tag,
) inherits bacula::params {

  include bacula::common
  include bacula::client
  include bacula::ssl
  include bacula::director::defaults
  include bacula::virtual

  case $db_type {
    /^(pgsql|postgresql)$/: { include bacula::director::postgresql }
    'none': { }
    default:                { fail('No db_type set') }
  }

  realize(Package[$packages])

  service { $services:
    ensure    => running,
    enable    => true,
    subscribe => File[$bacula::ssl::ssl_files],
    require   => Package[$packages],
  }

  file { "${conf_dir}/conf.d":
    ensure => directory,
  }

  file { "${conf_dir}/bconsole.conf":
    owner   => 'root',
    group   => $group,
    mode    => '0640',
    content => template('bacula/bconsole.conf.erb');
  }

  Concat {
    owner  => 'root',
    group  => $group,
    mode   => '0640',
    notify => Service[$services],
  }

  concat::fragment { 'bacula-director-header':
    order   => '00',
    target  => "${conf_dir}/bacula-dir.conf",
    content => template('bacula/bacula-dir-header.erb')
  }

  concat::fragment { 'bacula-director-tail':
    order   => '99999',
    target  => "${conf_dir}/bacula-dir.conf",
    content => template('bacula/bacula-dir-tail.erb')
  }

  bacula::messages { 'Standard-dir':
    console => 'all, !skipped, !saved',
    append  => '"/var/log/bacula/log" = all, !skipped',
    catalog => 'all',
  }

  bacula::messages { 'Daemon':
    mname   => 'Daemon',
    console => 'all, !skipped, !saved',
    append  => '"/var/log/bacula/log" = all, !skipped',
  }

  Bacula::Director::Pool <<||>> { conf_dir => $conf_dir }
  Bacula::Director::Storage <<||>> { conf_dir => $conf_dir }
  Bacula::Director::Client <<||>> { conf_dir => $conf_dir }

  if !empty($job_tag) {
    Bacula::Director::Job <<| tag == $job_tag |>> { conf_dir => $conf_dir }
  } else {
    Bacula::Director::Job <<||>> { conf_dir => $conf_dir }
  }

  Bacula::Fileset <<||>> { conf_dir => $conf_dir }

  Concat::Fragment <<| tag == "bacula-${director}" |>>

  concat { "${conf_dir}/bacula-dir.conf": }

  $sub_confs = [
    "${conf_dir}/conf.d/schedule.conf",
    "${conf_dir}/conf.d/storage.conf",
    "${conf_dir}/conf.d/pools.conf",
    "${conf_dir}/conf.d/job.conf",
    "${conf_dir}/conf.d/jobdefs.conf",
    "${conf_dir}/conf.d/client.conf",
    "${conf_dir}/conf.d/fileset.conf",
  ]

  concat { $sub_confs: }

  bacula::fileset { 'Common':
    files => ['/etc'],
  }

  bacula::job { 'RestoreFiles':
    jobtype  => 'Restore',
    fileset  => false,
    jobdef   => false,
    messages => 'Standard',
  }
}
