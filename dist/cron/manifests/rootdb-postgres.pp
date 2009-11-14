# class to handle postgres user crontab
# arbitrary cron names must be GLOBALLY unique
class cron::rootdb-postgres inherits cron {
    Cron    { 
        environment => [
            "PGHOST=/db/rootdb/sockets",
            "PSQLBCS='/usr/bin/psql -h /db/rootdb/sockets -d bcs -X -q'",
            "MAILTO=infra@backcountry.com",
        ],
        user        => postgres,
    }
    cron    {
        "hivol-vacuum":
            command => "test -d /db/rootdb/db/data && bin/vacuum-high-churn-tables > /dev/null",
            ensure  => present,
            minute  => '*/5';
        "medvol-vacuum":
            command => "test -d /db/bucardo/db/data && bin/vacuum-medium-churn-tables > /dev/null",
            ensure  => present,
            minute  => '*/15';
        "bc-vacuum-reindex":
            command => "test -d /db/rootdb/db/data && bin/bc_vacuum_analyze_reindex",
            ensure  => present,
            minute  => 15,
            hour    => 2;
        "bc-vacuum-reindex-ro1":
            environment => "PGHOST=/db/ro1/sockets",
            command => "test -d /db/ro1/db/data && bin/bc_vacuum_analyze_reindex",
            ensure  => present,
            minute  => 15,
            hour    => 2;
        "bucardo-purge-delta":
            command => "test -d /db/rootdb/db/data && (\$PSQLBCS -c \"select bucardo.bucardo_purge_delta('15 minutes'::interval)\" >/dev/null)",
            ensure  => present,
            minute  => '*/10';
        "pgsql-backup":
            command => "test -d /db/rootdb/db/data && bin/pgsql-backup",
            ensure  => present,
            minute  => 20,
            hour    => 1;
        "disk-watch":
            command => "test -d /db/rootdb/db/data && bin/disk-space-watch rootdb",
            ensure  => present,
            minute  => 0,
            hour    => 7;
        "disk-watch-ro1":
            environment => "PGHOST=/db/ro1/sockets",
            command => "test -d /db/ro1/db/data && bin/disk-space-watch ro1",
            ensure  => present,
            minute  => 0,
            hour    => 7;
        "kill-long-run":
            command => "test -d /db/rootdb/db/data && bin/kill_long_running_pg_connections.pl",
            ensure  => present,
            minute  => [ 5, 20, 35, 50 ];
    }
}
