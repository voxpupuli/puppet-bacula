# rsyslog configuration
class rsyslog {
    package { "rsyslog":    ensure  => present }
    package { "sysklogd":   ensure  => absent  }
    service { "rsyslog":
        ensure      => "running",
        hasrestart  => "true",
        hasstatus   => "true",
        restart     => "/etc/init.d/rsyslog restart",
        require     => [ File["/etc/rsyslog.conf"], Package["rsyslog"], Package["sysklogd"] ],
        subscribe   => File["/etc/rsyslog.conf"],
    }
    file    {
        "/etc/rsyslog.conf":
            source  => [
                        "puppet:///rsyslog/rsyslog.conf.$hostname",
                        "puppet:///rsyslog/rsyslog.conf",
                        ],
            ensure  => present;
        "/var/spool/rsyslog":
            ensure      => directory;
    }
}
