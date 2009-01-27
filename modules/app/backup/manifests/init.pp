# rsync backups
class backup {
    # Two files needed for backups
    file {
        "rsyncd.conf":
            path    => "/etc/rsyncd.conf",
            source  => "puppet:///backup/rsyncd.conf",
            mode    => "600",
            owner   => "root",
            group   => "root";
        "rsyncd.secrets":
            path    => "/etc/rsyncd.secrets",
            source  => "puppet:///backup/rsyncd.secrets", 
            mode    => "600",
            owner   => "root",
            group   => "root";
    }
}
