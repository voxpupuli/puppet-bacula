# class for handling bucardo user crontab
# arbitrary cron names must be GLOBALLY unique
class cron::rootdb-bucardo inherits cron {
    Cron    { 
        environment => "PSQLBUCARDO='psql -h /db/bucardo/sockets -d bucardo -X -q'",
        user        => bucardo,
    }
    cron    {
        "hichurn-vacuum":
            command => "test -d /db/bucardo/db/data && \$PSQLBUCARDO -c \"VACUUM pg_class\"",
            ensure  => present,
            minute  => '*/5';
        "purge-q-vacuum":
            command => "test -d /db/bucardo/db/data && \$PSQLBUCARDO -c \"SELECT bucardo_purge_q_table('5 minutes'::interval)\" >/dev/null && \$PSQLBUCARDO -c \"VACUUM ANALYZE q\"",
            ensure  => present,
            minute  => '*/5';
        "schema-backup":
            command => "test -d /db/bucardo/db/data && (cd /home/bucardo/backups/rootdb; /home/bucardo/bin/backup_bucardo_schema)",
            ensure  => present,
            minute  => 12,
            hour    => 7;
        "rare-syncs":
            command => "test -d /db/bucardo/db/data && /home/bucardo/bin/bucardo_ctl kick gwp rare --ctlquiet",
            ensure  => present,
            minute  => 19;
    }
}
