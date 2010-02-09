$mysql_root_pw='password'
include mysql::server
mysql_user{['test1@localhost', 'test2@localhost', 'test3@localhost']:
#  ensure => absent,
  ensure => present,
  require => Class['mysql::server'],
}
mysql_database{'test4':
  ensure => present,
}
