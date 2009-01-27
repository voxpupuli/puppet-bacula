# configures puppet clients
class puppet {
    file    {
        "puppet.init":
            path    => "/etc/init.d/puppet",
            source  => "puppet:///puppet/$operatingsystem/puppet.init",
            mode    => "755",
            owner   => "root",
            group   => "root";
        "puppet.conf":
            path    => "/etc/puppet/puppet.conf",
            content => template("puppet/puppet.erb"),
            mode    => "644",
            owner   => "root",
            group   => "root";
        "sysconfpuppet":
            path    => "/etc/sysconfig/puppet",
            content => template("puppet/sysconfpuppet.erb"),
            mode    => "644",
            owner   => "root",
            group   => "root";
    }
    service { "puppet":
        enable      => true,
        ensure      => running,
        require     => File["puppet.init"],
        subscribe   => File["puppet.conf"],
    }
}
