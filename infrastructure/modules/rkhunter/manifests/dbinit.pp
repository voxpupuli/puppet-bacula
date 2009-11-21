class rkhunter::dbinit {
  include rkhunter
  file{'/var/lib/rkhunter/tmp':
    owner   => root,
    group   => root,
    mode    => 0755,
    ensure  => directory,
    require => Package['rkhunter'], 
  }
  exec{'init_rkunter_db':
    command => 'rkhunter --propupd',
    path    => '/usr/bin',
    creates => '/var/lib/rkhunter/db/rkhunter.dat',
    require => [Package['rkhunter'], File['/var/lib/rkhunter/tmp']],
  }
}
