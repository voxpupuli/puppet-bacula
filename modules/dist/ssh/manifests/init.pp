# setup ssh client
class ssh {
   package  {"ssh":
        name    => $operatingsystem ? {
            redhat  => "openssh",
            default => "openssh",
        },
        ensure => present,
    }
    file {
        "/etc/ssh/ssh_config":
            owner   => "root",
            group   => "root",
            mode    => "644",
            source  => "puppet:///ssh/ssh_config",
            require => Package["ssh"];
        "/etc/ssh/ssh_known_hosts":
            owner   => "root",
            group   => "root",
            mode    => 644,
            source  => "puppet:///ssh/ssh_known_hosts",
            require => Package["ssh"];
    }
}
