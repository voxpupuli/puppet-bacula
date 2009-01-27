# sudo class
class sudo {
    package { "sudo": ensure => present }
    file    { "/etc/sudoers": 
        owner   => "root", 
        group   => "root", 
        mode    => "440",
        source  => "puppet:///sudo/sudoers",
        require => Package["sudo"],
    }
}
