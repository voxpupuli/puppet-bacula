# Class: bacula::confluence
#
# This class creates a define that creates a cron job to backup confluence
#
# Parameters:
#
# Actions:
#   - A define that creates a cron job to backup confluence
#
# Requires:
#
# Sample Usage:
#
# bacula::confluence { 'production': }
#
#
define bacula::confluence {

$backup_dir     = '/var/atlassian/application-data/backups/confluence-home'
$dirs_to_backup = '/var/atlassian/application-data/confluence/attachments /var/atlassian/application-data/confluence/config /var/atlassian/application-data/confluence/confluence.cfg.xml /var/atlassian/application-data/confluence/index'

  include bacula::params

  cron { "bacula_confluence_homedir_${name}":
    command => "rsync -plar --progress --delete $dirs_to_backup $backup_dir > /dev/null",
    user    => root,
    hour    => [0, 4, 8, 12, 16, 20],
    minute  => 16,
  }

  file { $backup_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root'
  }

  bacula::job { "${::fqdn}-confluence-${name}":
    files => $backup_dir,
  }
}
