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
    path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    creates => '/var/lib/rkhunter/db/rkhunter.dat',
    logoutput => on_failure,
    require => [
                 Package['rkhunter'],
                 File['/var/lib/rkhunter/tmp']
               ],
  }
}
