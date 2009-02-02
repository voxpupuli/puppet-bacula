# meta-class includes other rootdb-user crontabs
class cron::rootdb-alluser {
    include cron::rootdb-bucardo
    include cron::rootdb-interch
    include cron::rootdb-postgres
    include cron::rootdb-root
}
