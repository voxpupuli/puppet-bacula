# ensure monitoring daemons installed and configured
class monitor {
    package { ["net-snmp","nrpe","nagios-plugins"]: ensure => present }
    file    {
        "nrpe.cfg":
            path        => "/etc/nagios/nrpe.cfg",
            content     => template("monitor/nrpe_cfg.erb"),
            mode        => "644",
            owner       => "root",
            group       => "root";
        "snmpd.conf":
            path        => "/etc/snmp/snmpd.conf",
            content     => template("monitor/snmpd_conf.erb"),
            mode        => "644",      
            owner       => "root",
            group       => "root";  
        "/usr/local/libexec/nrpe_checks":
            ensure      => directory,
            recurse     => true,
            source      => "puppet:///monitor/nrpe_checks",
            ignore      => ".svn";
    } 
    service {
        "snmpd":
            enable      => true,
            hasrestart  => true,
            ensure      => running,
            require     => File["snmpd.conf"],
            subscribe   => File["snmpd.conf"];
        "nrpe":
            enable      => true,
            hasrestart  => true,
            ensure      => running,
            require     => File["nrpe.cfg"],
            subscribe   => File["nrpe.cfg"];
    }
}
