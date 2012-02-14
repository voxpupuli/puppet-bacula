node narvi {
  include role::server
  #class { "mysql::server": root_pw => hiera("mysql_root_pw")}
  $mysql_root_pw = hiera('mysql_root_pw')
  include mysql::server
  include service::projects

}

