# Class: bacula::postgres
#
# This class creates a define that creates a cron job to backup postgres databases
#
# Parameters:
#
# Actions:
#   - A define that creates a cron job to backup postgres databases
#
# Requires:
#
# Sample Usage:
#
# bacula::postgres { database_name: }
#
define bacula::postgres {

  include bacula::params
  include bacula::postgres::resources

  $homedir = $bacula::params::homedir

  cron { "bacula_postgres_${name}":
    command => "/bin/su -l postgres -c '/usr/bin/pg_dump ${name} --blobs --format=plain --create' | /bin/cat > ${homedir}/postgres/${name}.sql",
    user    => 'root',
    hour    => 0,
    minute  => 35,
    require => File["${homedir}/postgres"],
  }

  bacula::job { "${::fqdn}-postgres-${name}":
    files => "${homedir}/postgres/${name}.sql",
  }
}
