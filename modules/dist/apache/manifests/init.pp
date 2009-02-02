# ensure apache is installed
class apache {
    package { ["httpd"]: ensure => present }
    file    { "/etc/sysconfig/httpd":
        ensure      => present,
        owner       => "root",
        group       => "root",
        mode        => "644",
        source      => "puppet:///apache/httpd",
        require     => Package["httpd"],
    }
    service { "httpd":
        ensure      => running,
        enable      => true,
        subscribe   => File["/etc/sysconfig/httpd"],
    }
}
