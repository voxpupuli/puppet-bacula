class bind::server {
  package{'bind':}
  service{'named':
    ensure    => running,
    enable    => true,
    subscribe => Package['bind'],
  }
}
