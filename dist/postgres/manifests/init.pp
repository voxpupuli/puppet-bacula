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
  $user ,
  $password = undef ,
  $createdb = false,
  $superuser = false
) {

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

  exec{ "createuser ${cdb} ${su} ${user}":
    user => 'postgres',
  }

}

# TYPE  DATABASE        USER            CIDR-ADDRESS            METHOD
define postgres::hba(
  $type = 'user',
  $db = 'all',
  $user,
  $cidr,
  $method
) {

  $user = $name

  $pgver = "9.0"
  $pghbafile = "/etc/postgresql/${pgver}/main/pg_hba.conf"

  $linetoadd = "$type\t$db\t$user\t$cidr\t$method"

  exec{
    'mod_pghba':
      command => "printf \"$linetoadd\" >>$pghbafile && /usr/sbin/invoke-rc.d postgres reload",
      unless  => "grep -q \"$linetoadd\" $pghbafile",
  }

}
