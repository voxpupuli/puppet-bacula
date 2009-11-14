class cron {
    package {
        [
            "anacron", "cron-harness", "crontabs", "vixie-cron",
        ]:
        ensure  => present,
    }
    service {
        [
            "anacron", "crond",
        ]:
        enable      => true,
        subscribe   => [ Package["anacron"], Package["vixie-cron"] ],
    }
}
