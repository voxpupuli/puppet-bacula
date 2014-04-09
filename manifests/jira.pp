# Class: bacula::jira
#
# This class creates a define that creates a cron job to backup Jira
#
# Parameters:
#
# Actions:
#   - A define that creates a cron job to backup Jira
#
# Requires:
#
# Sample Usage:
#
# bacula::jira { 'production': }
#
#
define bacula::jira {

$backup_dir = '/var/atlassian/backup/jira-home'

  include bacula::params

  cron { "bacula_jira_homedir_${name}":
    command => '/var/atlassian/application-data/jira/sync-jira-home.sh >/dev/null',
    user    => root,
    hour    => [0, 4, 8, 12, 16, 20],
    minute  => 16,
  }

  if ! defined(File[$backup_dir]) {
    file { $backup_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root'
    }
  }

  if ! defined(File['/var/atlassian/application-data/jira/sync-jira-home.sh']) {
    file { '/var/atlassian/application-data/jira/sync-jira-home.sh':
      ensure  => file,
      group   => 'root',
      owner   => 'root',
      mode    => '0755',
      content => template('bacula/sync-jira-home.sh.erb')
    }
  }

  bacula::job { "${::fqdn}-jira-${name}":
    files => $backup_dir,
  }
}
