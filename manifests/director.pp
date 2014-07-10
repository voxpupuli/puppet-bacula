# Class: bacula::director
#
# This class installs and configures the Bacula Backup Director
#
# Parameters:
# * db_user: the database user
# * db_pw: the database user's password
# * monitor: should nagios be checking bacula backups, and I should hope so
# * password: password to connect to the director
# * sd_pass: the password to connect to the storage daemon
#
#
# Actions:
#  - Installs the bacula-director packages
#  - Installs the bacula storage daemon packages
#  - Starts the Bacula services
#  - Creates the /bacula mount point
#
# Requires:
#
# Sample Usage:
#
class bacula::director (
  $db_user  = 'bacula',
  $db_pw    = 'ch@ng3me',
  $db_name  = $db_user,
  $monitor  = true,
  $password = 'HoiuxVzotfxKC0o6bZeOTWM80KKdhCGNl4Iqflzwnr5pdSOgDKye9PmUxgupsgI',
  $sd_pass  = '52PbfrCejKZyemyT89NgCOKvLBXFebMcDBc2eNQt4UogyCbVp8KnIXESGHfqZCJ',
  $ssl      = $bacula::params::ssl,
) inherits bacula::params {

  if $bacula::params::db_type == 'mysql' {
    include mysql::server

    ## backup the bacula database  -- database are being backed up by being created in mysql::db
    #bacula::mysql { 'bacula': }

    mysql::db { 'bacula':
      user     => $db_user,
      password => $db_pw,
    }
    bacula::mysql { 'bacula': }
  }

  elsif $bacula::params::db_type == 'pgsql' {

    $make_bacula_tables = '/var/lib/bacula/make_bacula_tables'

    include profile::postgresql::install
    include profile::postgresql::configuration
    include profile::postgresql::pg_hba_rules

    postgresql::server::db { $db_name:
      user     => $db_user,
      password => postgresql_password($db_user, $db_pw),
      encoding => 'SQL_ASCII',
      require  => [ Class['profile::postgresql::install'], Package[$bacula_director_packages] ],
      before   => File[$make_bacula_tables]
    }

    file { $make_bacula_tables:
      content => template('bacula/make_bacula_postgresql_tables.erb'),
      owner   => 'bacula',
      mode    => '0777',
      before  => Exec["/bin/sh $make_bacula_tables"]
    }

    exec { "/bin/sh $make_bacula_tables":
      user        => 'bacula',
      refreshonly => true,
      subscribe   => Postgresql::Server::Db[$db_name],
      notify      => Service[bacula-director],
      require     => File[$make_bacula_tables]
    }
  }

  include bacula::params

  if $ssl == true {
    include bacula::dhkey
  }

  if $monitor == true {
    class { 'bacula::director::monitor':
      db_user => $db_user,
      db_pw   => $db_pw,
    }
  }

  package { [ $bacula::params::bacula_director_packages, $bacula_storage_packages ]:
    ensure => present,
  }

  service { $bacula::params::bacula_director_services:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$bacula::params::bacula_director_packages],
  }

  file { '/etc/bacula/conf.d':
    ensure  => directory,
  }

  file { '/etc/bacula/bconsole.conf':
    owner   => 'root',
    group   => 'bacula',
    mode    => '0640',
    content => template('bacula/bconsole.conf.erb');
  }

  concat::fragment { 'bacula-director-header':
    order   => '00',
    target  => '/etc/bacula/bacula-dir.conf',
    content => template('bacula/bacula-dir-header.erb')
  }

  Bacula::Director::Pool <<||>>
  Concat::Fragment <<| tag == "bacula-${::fqdn}" |>>

  concat { '/etc/bacula/bacula-dir.conf':
    owner  => root,
    group  => bacula,
    mode   => 640,
    notify => Service[$bacula::params::bacula_director_services];
  }

  $sub_confs = [
    '/etc/bacula/conf.d/schedule.conf',
    '/etc/bacula/conf.d/storage.conf',
    '/etc/bacula/conf.d/pools.conf',
    '/etc/bacula/conf.d/job.conf',
    '/etc/bacula/conf.d/jobdefs.conf',
    '/etc/bacula/conf.d/client.conf',
    '/etc/bacula/conf.d/fileset.conf',
  ]

  concat { $sub_confs:
    owner  => root,
    group  => bacula,
    mode   => '0640',
    notify => Service[$bacula::params::bacula_director_services];
  }

  bacula::fileset { 'Common':
    files => ['/etc'],
  }

  bacula::job { 'RestoreFiles':
    jobtype => 'Restore',
    fileset => false,
  }



}
