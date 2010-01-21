class rkhunter{
  include cron
  package{'rkhunter':
    ensure => latest,
  }
  File{
    owner   => root,
    group   => root,
    require => Package['rkhunter'],
  }
  file{'/etc/rkhunter.conf':
    mode   => 0640, 
    source => 'puppet:///modules/rkhunter/rkhunter.conf',
  } 
  file{'/etc/cron.daily/01-rkhunter':
    mode   => 0664, 
    source => 'puppet:///modules/rkhunter/01-rkhunter.sh',
  }
}
