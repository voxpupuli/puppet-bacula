# This class installs and configures the Bacula Director
#
# @param conf_dir
# @param db_name: the database name
# @param db_pw: the database user's password
# @param db_type
# @param db_user: the database user
# @param director
# @param director_address
# @param group
# @param homedir
# @param job_tag
# @param listen_address
# @param max_concurrent_jobs
# @param messages
# @param packages
# @param password
# @param password: password to connect to the director
# @param port The listening port for the Director
# @param rundir
# @param services
# @param storage_name
# @param manage_db
# @param db_address
# @param db_port
#
# @example
#   class { 'bacula::director':
#     storage => 'mystorage.example.com'
#   }
#
# TODO director_address is only used by bconsole, and is confusing as director is likely the same 
#
class bacula::director (
  String $db_type,
  $messages,
  Array $packages,
  String $services,
  Boolean $manage_db          = true,
  String $conf_dir            = $bacula::conf_dir,
  String $db_name             = 'bacula',
  String $db_pw               = 'notverysecret',
  String $db_user             = 'bacula',
  Optional[String] $db_address = undef,
  Optional[String] $db_port    = undef,
  $director_address           = $bacula::director_address,
  $director                   = $trusted['certname'], # director here is not bacula::director
  $group                      = $bacula::bacula_group,
  $homedir                    = $bacula::homedir,
  $job_tag                    = $bacula::job_tag,
  $listen_address             = $facts['ipaddress'],
  $max_concurrent_jobs        = '20',
  $password                   = 'secret',
  $port                       = '9101',
  $rundir                     = $bacula::rundir,
  $storage_name               = $bacula::storage_name,
) inherits ::bacula {

  include ::bacula::director::defaults

  case $db_type {
    /^(pgsql|postgresql)$/: { include ::bacula::director::postgresql }
    /^(mysql)$/:            { include ::bacula::director::postgresql }
    'none':                 { }
    default:                { fail('No db_type set') }
  }

  # Packages are virtual due to some platforms shipping the SD and Dir as
  # part of the same package.
  include ::bacula::virtual

  # Allow for package names to include EPP syntax for db_type
  $package_names = $packages.map |$p| {
    $package_name = inline_epp($p, {
      'db_type' => $db_type
    })
  }

  realize(Package[$package_names])

  service { $services:
    ensure  => running,
    enable  => true,
    require => Package[$package_names],
  }

  if $::bacula::use_ssl == true {
    include ::bacula::ssl
    Service[$services] {
      subscribe => File[$::bacula::ssl::ssl_files],
    }
  }

  file { "${conf_dir}/conf.d":
    ensure => directory,
  }

  file { "${conf_dir}/bconsole.conf":
    owner     => 'root',
    group     => $group,
    mode      => '0640',
    show_diff => false,
    content   => template('bacula/bconsole.conf.erb');
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
    content => template('bacula/bacula-dir-header.erb'),
  }

  concat::fragment { 'bacula-director-tail':
    order   => '99999',
    target  => "${conf_dir}/bacula-dir.conf",
    content => template('bacula/bacula-dir-tail.erb'),
  }

  create_resources(bacula::messages, $messages)
  # Realize any clients or storage that have the same director specified
  Bacula::Director::Storage <<| tag == "bacula-${director}" |>> { conf_dir => $conf_dir }
  Bacula::Director::Client <<| tag == "bacula-${director}" |>> { conf_dir => $conf_dir }

  if $job_tag {
    Bacula::Director::Fileset <<| tag == "bacula-${director}" |>> { conf_dir => $conf_dir }
    Bacula::Director::Job <<| tag == $job_tag |>> { conf_dir => $conf_dir }
    # TODO tag pool resources on export when job_tag is defined
    Bacula::Director::Pool <<|tag == $job_tag |>> { conf_dir => $conf_dir }
  } else {
    Bacula::Director::Fileset <<||>> { conf_dir => $conf_dir }
    Bacula::Director::Job <<||>> { conf_dir => $conf_dir }
    Bacula::Director::Pool <<||>> { conf_dir => $conf_dir }
  }

  Concat::Fragment <<| tag == "bacula-${director}" |>>

  concat { "${conf_dir}/bacula-dir.conf":
    show_diff => false,
  }

  $sub_confs = [
    "${conf_dir}/conf.d/schedule.conf",
    "${conf_dir}/conf.d/pools.conf",
    "${conf_dir}/conf.d/job.conf",
    "${conf_dir}/conf.d/jobdefs.conf",
    "${conf_dir}/conf.d/fileset.conf",
  ]

  $sub_confs_with_secrets = [
    "${conf_dir}/conf.d/client.conf",
    "${conf_dir}/conf.d/storage.conf",
  ]

  concat { $sub_confs: }

  concat { $sub_confs_with_secrets:
    show_diff => false,
  }

  bacula::director::fileset { 'Common':
    files => ['/etc'],
  }

  bacula::job { 'RestoreFiles':
    jobtype  => 'Restore',
    jobdef   => false,
    messages => 'Standard',
    fileset  => 'Common',
  }
}
