# class to handle root user crontab
# arbitrary cron names must be GLOBALLY unique
class cron::rootdb-root inherits cron {
    Cron    { 
        environment => "PGHOST=/db/rootdb/sockets",
        user        => root,
    }
    cron    {
        "campdb-refresh":
            command => "test -d /db/rootdb/db/data && ln -sf /root/bin/update-camp0.orig  /root/bin/update-camp0",
            ensure  => present,
            minute  => 0,
            hour    => 0,
            weekday => 6;
        "campdb-refresh2":
            command => "test -d /db/rootdb/db/data && ln -sf /root/bin/update-camp0.empty /root/bin/update-camp0",
            ensure  => present,
            minute  => 0,
            hour    => 0,
            weekday => 0;
        "snapshot-create":
            command => "test -d /db/rootdb/db/data && /root/bin/make-rootdbsnap-netapp",
            ensure  => present,
            minute  => 5,
            hour    => 0;
        "snapshot-cleanup":
            command => "test -d /db/rootdb/db/data && /root/bin/remove-rootdbsnap-netapp",
            ensure  => present,
            minute  => 10,
            hour    => 0;
        "grant-analyze-temp":
            command => "test -d /db/rootdb/db/data && /root/bin/grant-and-analyze.pl rootdb",
            ensure  => present,
            minute  => 0,
            hour    => 2;
        "grant-analyze-temp-ro1":
            environment => "PGHOST=/db/ro1/sockets",
            command => "test -d /db/ro1/db/data && /root/bin/grant-and-analyze.pl ro1 ",
            ensure  => present,
            minute  => 0,
            hour    => 2;
    }
}
