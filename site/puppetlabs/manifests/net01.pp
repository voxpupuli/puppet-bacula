# Net01 network management node
#
# for things like DNS, DHCP, and friends. 

class puppetlabs::net01 {

  # rsyslog hackery.
  file{ '/etc/rsyslog.d/aruba.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_rsyslog_aurba.conf',
  }

  file{ '/etc/rsyslog.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_rsyslog.conf',
  }

  file{ '/etc/logrotate.d/aruba':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppetlabs/net01_logrotate_aruba',
  }


  service{ 'rsyslog':
    hasstatus  => true,
    hasrestart => true,
    ensure     => running,
    enable     => true,
    subscribe  => [ File['/etc/rsyslog.conf'],
                    File['/etc/rsyslog.d/aruba.conf'] ],
  }

}
