# This is hack, and just to get something off the ground. I need to
# move this around, make it check for debian, as that's all it will
# work on. Probably map some things.

class postgres {

  postgres::user{ 'superuser':
    createdb  => true,
    superuser => true,
  }

  postgres::hba{ 'superuser':
    type     => 'user',
    database => 'ALL',
    cidr     => '192.168.100.0/24',
    method   => 'MD5',
  }


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
