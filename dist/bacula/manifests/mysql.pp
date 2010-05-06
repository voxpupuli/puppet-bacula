# Class: bacula::mysql
#
# This class creates a define that creates a cron job to backup MySQL databases
#
# Parameters:
#
# Actions:
#   - A define that creates a cron job to backup MySQL databases
#
# Requires:
#
# Sample Usage:
#
# bacula::mysql { database_name: }
#
define bacula::mysql {
    include bacula

    cron { "bacula_mysql_$name":
      command => "mysqldump -p$mysql_root_pw $name > /var/lib/bacula/mysql/$name.sql",
      user => root,
      hour => 0,
      minute => 15,
      require => File['/var/lib/bacula/mysql'],
    }
}
