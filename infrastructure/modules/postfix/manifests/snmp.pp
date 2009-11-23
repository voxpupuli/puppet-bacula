class postfix::snmp {
  include snmp, postfix
  # track check_ports.conf changes 
  file {'fetch_mail_statistics.pl':
    name     => '/usr/local/sbin/fetch_mail_statistics.pl',
    ensure   => present,
    replace  => true,
    owner    => 'root',                        
    group    => 'root',
    mode     => '0700',
    source   => 'puppet:///postfix/fetch_mail_statistics.pl',
    require  => Package['postfix'],
  }
  fragment{'postfix':
    order     => '99',
    directory => '/etc/snmp/snmpd.conf.d',
    source    => 'puppet:///modules/postfix/snmpd.conf',
    require   => Package['net-snmp'],
  }
}
