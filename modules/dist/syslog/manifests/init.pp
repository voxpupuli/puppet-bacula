# legacy syslog class
class syslog {
    file { "/etc/syslog.conf":
        ensure    => present,
        owner     => "root",
        group     => "root",
        mode      => "644",
        source    => "puppet:///syslog/syslog.conf",
    }
    service { "syslog":
        enable    => "true",
        ensure    => "running",
        subscribe => File["/etc/syslog.conf"],
    }
}
