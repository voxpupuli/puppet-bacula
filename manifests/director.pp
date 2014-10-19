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
#   include bacula::director
#
class bacula::director (
  $port                = '9101',
  $db_user             = 'bacula',
  $db_pw               = 'notverysecret',
  $db_name             = 'bacula',
  $password            = 'secret',
  $max_concurrent_jobs = '20',
  $packages            = $bacula::params::bacula_director_packages,
  $services            = $bacula::params::bacula_director_services,
  $homedir             = $bacula::params::homedir,
  $rundir              = $bacula::params::rundir,
  $conf_dir            = $bacula::params::conf_dir,
  $storage             = $bacula::params::bacula_storage,
) inherits bacula::params {

  include bacula::common
  include bacula::client
  include bacula::ssl
  include bacula::director::database
  include bacula::director::defaults

  package { $packages:
    ensure => present,
  }

  service { $services:
    ensure     => running,
    enable     => true,
    subscribe  => File[$bacula::ssl::ssl_files],
    require    => Package[$packages],
  }

  file { "${conf_dir}/conf.d":
    ensure => directory,
  }

  file { "${conf_dir}/bconsole.conf":
    owner   => 'root',
    group   => 'bacula',
    mode    => '0640',
    content => template('bacula/bconsole.conf.erb');
  }

  Concat {
    owner  => 'root',
    group  => 'bacula',
    mode   => '0640',
    notify => Service[$services],
  }

  concat::fragment { 'bacula-director-header':
    order   => '00',
    target  => "${conf_dir}/bacula-dir.conf",
    content => template('bacula/bacula-dir-header.erb')
  }

  Bacula::Director::Pool <<||>>
  Concat::Fragment <<| tag == "bacula-${::fqdn}" |>>

  concat { "${conf_dir}/bacula-dir.conf": }

  $sub_confs = [
    '/etc/bacula/conf.d/schedule.conf',
    '/etc/bacula/conf.d/storage.conf',
    '/etc/bacula/conf.d/pools.conf',
    '/etc/bacula/conf.d/job.conf',
    '/etc/bacula/conf.d/jobdefs.conf',
    '/etc/bacula/conf.d/client.conf',
    '/etc/bacula/conf.d/fileset.conf',
  ]

  concat { $sub_confs: }

  bacula::fileset { 'Common':
    files => ['/etc'],
  }

  bacula::job { 'RestoreFiles':
    jobtype => 'Restore',
    fileset => false,
  }
}
