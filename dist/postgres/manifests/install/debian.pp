# This is hack, and just to get something off the ground. I need to
# move this around, make it check for debian, as that's all it will
# work on. Probably map some things.

# Defaults to 9.0 on squeeze, via backports.

class postgres::install::debian {

  $pgversion = '9.0' # if you wish, this could move to it's
                             # own params class.

  if $operatingsystem != 'debian' {
    fail( "$module_name is Debian only." )
  }

  # Defaults for this class, because I'm lazy.
  File{ owner => 'root', group => 'root', mode => '0644' }
  Apt::Pin{ release  => 'squeeze-backports', priority => '1001' }

  # Install postgres from backports
  apt::pin{
    [ "postgresql-${pgversion}", "postgresql-client-${pgversion}", 'postgresql-common' ,
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
    'refresh_apts_pre_postgres_install':
      command     => '/usr/bin/aptitude --quiet update',
      refreshonly => 'true',
      subscribe   => File['/etc/apt/sources.list.d/backports.list'],
  }

  package{ "postgresql-${pgversion}": ensure => present, require => Exec['refresh_apts_pre_postgres_install'] }


}
