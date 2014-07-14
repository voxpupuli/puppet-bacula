# Rotates backups that match a specific name in a target folder
define bacula::rotate (
  $count       = '7',
  $work_dir    = '/usr/local/bin',
  $backup_dir,
  $backup_name,
  $hour        = '0',
  $minute      = '15',
  $owner       = 'root',
  $group       = 'root'
) {

  cron { "rotate_${title}":
    command => "${work_dir}/rotate_${title} &> /dev/null",
    user    => 'root',
    hour    => $hour,
    minute  => $minute
  }

  file { "${work_dir}/rotate_${title}":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0700',
    content => template('bacula/rotate-backups.erb'),
    require => File[$backup_dir]
  }
}
