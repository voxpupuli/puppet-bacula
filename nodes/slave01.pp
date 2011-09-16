node slave01 {
  include role::server
  $mysql_root_pw = 'T3sting@'
  include mysql::server
  include jenkins::slave
}

