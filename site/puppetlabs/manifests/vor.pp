class puppetlabs::vor {

  File{ owner => 'root', group => 'root', mode => '0644' }
  Aptpin{ release  => 'squeeze-backports', priority => '200' }

  # Install postgres from backports
  aptpin{
    [ 'postgresql-9.0', 'postgresql-client-9.0', 'postgresql-common' ]:
      ensure => present,
      before => File['/etc/apt/sources.list.d/backports.list'],
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

define aptpin( $release, $priority, $ensure ) {
  $package = $name
  file{
    "/etc/apt/preferences.d/$package":
      ensure   => $ensure,
      content  => "Package: $package\nPin: release a=$release\nPin-Priority: $priority\n",
      owner => 'root',
      group => 'root',
      mode => '0644'
  }
}
