# This is hack, and just to get something off the ground. I need to
# move this around, make it check for debian, as that's all it will
# work on. Probably map some things.

class postgres::install::debian {

  $pgversion = '9.0' # if you wish, this could move to it's own params
                     # class.

  case $operatingsystem {
    default:  { fail "$module_name is Debian only."}
    debian,ubuntu:  {}
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
    'refresh_apts':
      command     => '/usr/bin/aptitude --quiet update',
      refreshonly => 'true',
      subscribe   => File['/etc/apt/sources.list.d/backports.list'],
  }

  package{ "postgresql-${pgversion}": ensure => present, require => Exec['refresh_apts'] }


}

define postgres::user(
  $user = undef,
  $password = undef ,
  $createdb = false,
  $superuser = false
) {

  if $user == undef {
    $username = $name
  } else {
    $username = $user
  }

  if $superuser == true {
    $su = "-s"
  } else {
    $su = "-S"
  }

  if $createdb == true {
    $cdb = "-d"
  } else {
    $cdb = "-D"
  }

  exec{ "/usr/bin/createuser ${cdb} ${su} ${username}":
    user => 'postgres', # run as postgres user.
  }

}

# TYPE  DATABASE        USER            CIDR-ADDRESS            METHOD
define postgres::hba(
  $type = 'user',
  $database = 'all',
  $cidr,
  $method
) {

  $user = $name

  $pgver = "9.0"
  $pghbafile = "/etc/postgresql/${pgver}/main/pg_hba.conf"

  $linetoadd = "$type\t$database\t$user\t$cidr\t$method\n"

  exec{
    'mod_pghba':
      command => "/usr/bin/printf \"$linetoadd\" >>$pghbafile && /usr/sbin/invoke-rc.d postgresql reload",
      unless  => "/bin/grep -q \"$linetoadd\" $pghbafile",
  }

}
