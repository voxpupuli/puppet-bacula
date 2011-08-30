class puppetlabs::vor {

  # Defaults for this class, because I'm lazy.
  File{ owner => 'root', group => 'root', mode => '0644' }
  Apt::Pin{ release  => 'squeeze-backports', priority => '1001' }

  # Install postgres from backports
  apt::pin{
    [ 'postgresql-9.0', 'postgresql-client-9.0', 'postgresql-common' ,
      'postgresql-client-common' , 'libpq5']:
      before => File['/etc/apt/sources.list.d/backports.list'],
  }

  # Do this, as per http://backports-master.debian.org/Instructions/
  # so we get backports updates.
  apt::pin{ '*':
    release  => 'lenny-backports',
    priority => '200',
    filename => 'star'
  }

  file{
    '/etc/apt/sources.list.d/backports.list':
      ensure   => file,
      content  => 'deb http://backports.debian.org/debian-backports squeeze-backports main',
  }

  exec{
    'refresh_apts':
      command     => '/usr/bin/aptitude --quiet update',
      refreshonly => 'true',
      subscribe   => File['/etc/apt/sources.list.d/backports.list'],
  }

  package{ 'postgresql-9.0': ensure => present, require => Exec['refresh_apts'] }

  # This is dirty and a lot of the above should be moved to this
  # class.
  class{ 'postgres':
    require => Package['postgresql-9.0']
  }

}

