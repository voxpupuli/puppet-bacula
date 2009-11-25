class bind::server {
  include bind
  require bind
  package{'bind':
    ensure => installed,
    notify => Service['named'],
  }
  file{'/etc/named.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    ensure  => file,
    require => Package['bind'],
    notify  => Service['named'],
  }
  service{'named':
    ensure    => running,
    enable    => true,
    subscribe => Package['bind'],
  }
}
