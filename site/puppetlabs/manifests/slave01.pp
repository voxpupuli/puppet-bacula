class puppetlabs::slave01 {
  $mysql_root_pw = 'T3sting@'
  include mysql::server
  include jenkins::slave
}

