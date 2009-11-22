class iptables {
  package{'iptables':
    ensure => installed,
  }
  File{
    owner => 'root',
    group => 'root',
    mode  => 0600,
    require  => Package["iptables"],
  }
  file { "iptables":
    name     => "/etc/sysconfig/iptables",
    backup   => ".bak",
  }
  # track iptables-config changes 
  file { "iptables-config":
    name     => "/etc/sysconfig/iptables-config",
    backup   => local,
  }
  file { "/proc/net/ip_tables_names":
    mode => 0444,
  }
  service { "iptables":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [ Package["iptables"], 
                    File["iptables"], 
                    File["iptables-config"] 
                  ],
  }
}
