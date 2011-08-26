class puppetlabs::vor {

  File{ owner => 'root', group => 'root', mode => '0644' }
  Aptpin{ release  => 'squeeze-backports', priority => '1001' }

  # Install postgres from backports
  aptpin{
    [ 'postgresql-9.0', 'postgresql-client-9.0', 'postgresql-common' ,
      'postgresql-client-common' , 'libpq5']:
      before => File['/etc/apt/sources.list.d/backports.list'],
  }

  # Do this, as per http://backports-master.debian.org/Instructions/
  # so we get backports updates.
  aptpin{ '*':
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

}

define aptpin( $release, $priority, $filename = undef, $ensure = 'present' ) {
  # get around naming things such as '*'
  if $filename == undef {
    $fname = $name
  } else {
    $fname = $filename
  }

  file{
    "/etc/apt/preferences.d/${fname}.pref":
      ensure   => $ensure,
      content  => "Package: $name\nPin: release a=$release\nPin-Priority: $priority\n",
      owner => 'root',
      group => 'root',
      mode => '0644'
  }
}
