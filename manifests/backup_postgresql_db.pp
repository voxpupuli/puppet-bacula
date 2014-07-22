# This define creates a database backup job on a target host, a rotate script to rotate old backups and a bacula job to export backups to the backup target
#
# Sample usage
#
# bacula::backup_postgresql_db { my_db:
#   db_host     => my_host_or_ip,
#   db_pass     => db_password,
#   db_user     => db_user,
# }
#
define bacula::backup_postgresql_db (
  $hour        = '0', # When to run the backup job. The rotate job runs automatically at 12:15am
  $minute      = '15',
  $backup_path = '/var/lib/postgresql/backups',
  $keep        = '7', # Choose how many backups to keep on the target disk
  $db_host,
  $db_pass,
  $db_user,
  $db_name     = $title
) {

  $files = "${backup_path}/${title}"

  include bacula

  cron { "backup_postgresql_db_${title}":
    command => "/usr/local/bin/${title}_backup >/dev/null",
    user    => 'root',
    hour    => $hour,
    minute  => $minute
  }

  bacula::rotate { $title:
    backup_dir  => $files,
    backup_name => $title,
    count       => $keep
  }

  postgresql_backup::db { $title:
    db_host     => $db_host,
    db_pass     => $db_pass,
    db_user     => $db_user,
    db_name     => $db_name,
    backup_path => $files
  }

  file { $files:
    ensure => directory
  }

  bacula::job { "${::fqdn}-backup_postgresql_db_${title}":
    files   => $files,
    require => File[$files]
  }
}
