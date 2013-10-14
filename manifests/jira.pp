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

  include bacula::params

  cron { "bacula_jira_${name}":
    command => '/usr/local/bin/jira-backup',
    user    => root,
    hour    => [0, 4, 8, 12, 16, 20],
    minute  => 15,
  }

  bacula::job { "${::fqdn}-jira-${name}":
    files => hiera('jirabackup::backup_dir'),
  }
}
