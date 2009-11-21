class bind::server {
  include bind
  require bind
  package{'bind':
    ensure => installed,
  }
  service{'named':
    ensure    => running,
    enable    => true,
    subscribe => Package['bind'],
  }
}
