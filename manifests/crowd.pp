# Class: bacula::crowd
#
# This class creates a define that creates a cron job to backup crowd
#
# Parameters:
#
# Actions:
#   - A define that creates a cron job to backup crowd
#
# Requires:
#
# Sample Usage:
#
# bacula::crowd { 'production': }
#
#
define bacula::crowd {

$backup_base = '/var/atlassian/backup'
$backup_dir  = '/var/atlassian/backup/crowd-home'

  include bacula::params

  cron { "bacula_crowd_homedir_${name}":
    command => '/var/atlassian/crowd-home/sync-crowd-home.sh >/dev/null',
    user    => root,
    hour    => [0, 4, 8, 12, 16, 20],
    minute  => 16,
  }

  if ! defined(File[$backup_dir]) {
    file { $backup_base:
      ensure => directory,
      owner  => 'root',
      group  => 'root'
    }
    file { $backup_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root'
    }
  }

  if ! defined(File['/var/atlassian/crowd-home/sync-crowd-home.sh']) {
    file { '/var/atlassian/crowd-home/sync-crowd-home.sh':
      ensure  => file,
      group   => 'root',
      owner   => 'root',
      mode    => '0755',
      content => template('bacula/sync-crowd-home.sh.erb')
    }
  }

  bacula::job { "${::fqdn}-crowd-${name}":
    files => $backup_dir,
  }
}
