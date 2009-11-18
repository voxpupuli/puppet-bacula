class rkhunter{
  package{'rkhunter':}
  file{'/etc/rkhunter.conf':
    source  => 'puppet:///rkhunter/rkhunter.conf',
    require => Package['/etc/rkhunter.conf'],
  } 
  include rkhunter::dbinit
  file{'/etc/cron.daily/01-rkhunter':
    source  => 'puppet:///rkhunter/01-rkhunter.sh',
    mode    => 0755,
    require => Package['/etc/rkhunter.conf'],
  }
}
