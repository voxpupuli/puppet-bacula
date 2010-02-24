class snmp{
  Package{
    notify => Service["snmpd"],
    ensure => installed,
  }
  package { 'net-snmp':}
  package { ['net-snmp-libs', 'net-snmp-utils']:
    require  => Package["net-snmp"],
  }
  service{"snmpd":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  fragment{'snmp-header':
    order     => '00',
    filename  => '/etc/snmp/snmpd.conf',
    source    => 'puppet:///modules/snmp/00header.conf',
    require   => Package['net-snmp'],
  }
  fragment::concat{'/etc/snmp/snmpd.conf':
     notify => Service[snmpd],
  }
}
