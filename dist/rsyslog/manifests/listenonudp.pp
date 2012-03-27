class rsyslog::listenonudp {

  include rsyslog

  file{ '/etc/rsyslog.d/listenonudp.conf':
    owner   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/rsyslog/listenonudp.conf',
    notify  => Service['rsyslog'],
  }

}
