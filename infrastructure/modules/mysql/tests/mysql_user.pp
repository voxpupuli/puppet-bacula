$mysql_root_pw='password'
include mysql::server
database_user{['test1@localhost', 'test2@localhost', 'test3@localhost']:
#  ensure => absent,
  ensure => present,
  password_hash => mysql_password('blah2'),
  require => Class['mysql::server'],
}
