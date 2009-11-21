class rkhunter{
  include cron
  package{'rkhunter':}
  File{
    owner => root,
    group => root,
  }
  file{'/etc/rkhunter.conf':
    source  => 'puppet:///rkhunter/rkhunter.conf',
    require => Package['rkhunter'],
  } 
  file{'/etc/cron.daily/01-rkhunter':
    source  => 'puppet:///rkhunter/01-rkhunter.sh',
    mode    => 0755,
    require => File['/etc/rkhunter.conf'],
  }
}
