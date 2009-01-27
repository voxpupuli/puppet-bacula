# cofnigures the puppetmaster
class puppet::server inherits puppet {
    $puppetlib = "/var/lib/puppet" 
    File["puppet.conf"] {
        content => template("puppet/puppet.erb","puppet/server.erb"),
        notify  => Service["puppetmaster"],
    }
    file    {
        "$puppetlib/rrd":
            ensure  => directory,
            mode    => "755",
            owner   => "puppet",
            group   => "puppet";
        ["$puppetlib/reports","$puppetlib/ssl","/var/log/puppet"]:
            ensure  => directory,
            mode    => "750",
            owner   => "puppet",
            group   => "puppet";
        ["$puppetlib","$puppetlib/manifests","$puppetlib/modules"]:
            ensure  => directory,
            mode    => "755",
            owner   => "root",
            group   => "root";
        "puppetmaster.init":
            ensure  => present,
            path    => "/etc/init.d/puppetmaster",
            source  => "puppet:///puppet/$operatingsystem/puppetmaster.init",
            mode    => "755",
            owner   => "root",
            group   => "root";
        "fileserver.conf":
            ensure  => present,
            path    => "/etc/puppet/fileserver.conf",
            source  => "puppet:///puppet/fileserver.conf",
            mode    => "644",
            owner   => "root",
            group   => "root";
    }
    service {"puppetmaster":
        enable  => true,
        ensure  => running,
        require => File["puppetmaster.init"],
        require => File["/var/lib/puppet"],
        require => File["/var/lib/puppet/modules"],
        require => File["/var/lib/puppet/manifests"],
        require => File["puppet.conf"],
        subscribe => FIle["puppet.conf"],
    }
}
