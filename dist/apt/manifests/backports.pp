# including this will get a backports for whatever version of
# debian/ubuntu you're running. You can set it if you feel you must,
# but don't.

class apt::backports( $release=undef ) {

  if release == undef {
    $releasename = $lsbdistcodename
  } else {
    $releasename = $release
  }

  if $operatingsystem == 'debian' {
    $repourl = 'http://backports.debian.org/debian-backports'
    $repocomponent = 'main'
  }

  if $operatingsystem == 'ubuntu' {
    $repourl = 'http://archive.ubuntu.com/ubuntu'
    $repocomponent = 'universe multiverse restricted'
  }

  if $repourl == undef {
    fail( "$module_name is Debian & Umbongo only." )
  }


  # Defaults for this class, because I'm lazy.
  File{ owner => 'root', group => 'root', mode => '0644' }

  # Do this, as per http://backports-master.debian.org/Instructions/
  # so we get backports updates.
  apt::pin{ '*':
    release  => "${releasename}-backports",
    priority => '200',
    filename => 'star'
  }

  file{
    '/etc/apt/sources.list.d/backports.list':
      ensure   => file,
      content  => "deb ${repourl} ${releasename}-backports ${repocomponent}",
  }

  exec{
    'refresh_apts_pre_postgres_install':
      command     => '/usr/bin/aptitude --quiet update',
      refreshonly => 'true',
      subscribe   => File['/etc/apt/sources.list.d/backports.list'],
  }

}
