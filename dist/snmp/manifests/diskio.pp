class snmp::diskio {
  include snmp
  file { "/usr/sbin/snmpdiskio":
    owner  => 'root',
    group  => 'root',
    mode   => '0550',
    source => "puppet:///modules/snmp/snmpdiskio",
    notify => Fragment["diskio"],
  }
  fragment { "diskio":
    order     => 01,
    filename  => "/etc/snmp/snmpd.conf.d",
    source    => "puppet:///modules/snmp/diskio.conf",
    require   => Package['net-snmp'],
  }
}
