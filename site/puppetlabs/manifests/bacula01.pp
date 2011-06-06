class puppetlabs::bacula01 {

  $mysql_root_pw = 'y0PM46FbrF72'
  include mysql::server

  class { "bacula::director":
    db_user => 'bacula',
    db_pw   => 'ijdhx8jsd2KJshd',
  }

}

