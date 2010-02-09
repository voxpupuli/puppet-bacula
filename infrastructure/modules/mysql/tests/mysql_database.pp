$mysql_rootpw='password'
include mysql::server

mysql_database{"test1":
  ensure => present,
}
#mysql_database{'test2':
#  ensure => present,
#  args   => 'character set utf8',
#}
