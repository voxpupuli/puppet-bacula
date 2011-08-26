class puppetlabs::vor {

  File{ owner => 'root', group => 'root', mode => '0644' }

  # Install postgres from backports
  file{
    '/etc/preferences.d/postgresql9':
      ensure   => file,
      content  => "Package: postgresql\nPin: release a=squeeze-backports\nPin-Priority: 200\n";
    '/etc/apt/sources.list.d/backports.list':
      ensure   => file,
      content  => 'deb http://backports.debian.org/debian-backports squeeze-backports main',
      require  => File['/etc/preferences.d/postgresql9'];
  }

  exec{
    'refresh_apts':
      command     => '/usr/bin/aptitude --quiet update',
      refreshonly => 'true',
      require     => File['/etc/apt/sources.list.d/backports.list'],
  }

  package{ 'postgresql-9.0': ensure => present, require => Exec['refresh_apts'] }

}
