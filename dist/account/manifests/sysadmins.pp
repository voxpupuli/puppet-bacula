class users::sysadmins {
  if(! $my_sysadmins) {
    fail('must set \$my_sysadmins')
  }
  include sudo
  group{'sysadmin':
    ensure => present
  }
  $password = sha1('asdf1234')
  users::create{$my_sysadmins:
    password => $password,
    comment  => 'creating sysadmin user',
  }
}
