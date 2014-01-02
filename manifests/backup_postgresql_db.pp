define bacula::backup_postgresql_db (
  $hour        = [0, 4, 8, 12, 16, 20], # Every four hours
  $minute      = '15',                    # On the 15 minute mark
  $backup_path = '/var/lib/postgresql/backups'
) {

  if ! defined(Class['bacula']) {
    class { 'bacula': }
  }

  cron { "backup_postgresql_db_${title}":
    command => "/usr/local/bin/${title}_backup >/dev/null",
    user    => 'root',
    hour    => $hour,
    minute  => $minute
  }

  bacula::job { "${::fqdn}-backup_postgresql_db_${title}":
    files => $backup_path
  }
}
