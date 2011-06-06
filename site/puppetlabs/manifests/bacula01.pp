class puppetlabs::bacula01 {

  $mysql_root_pw = 'y0PM46FbrF72'
  include mysql::server

  class { "bacula::director":
    db_user => 'bacula',
    db_pw   => 'ijdhx8jsd2KJshd',
  }

  # Backup
  $bacula_password = 'YgBDlDIYfOAYC6UYRX28QD3Q7S3UYLBuGUBW9'
  $bacula_director = 'bacula01.puppetlabs.lan'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }


}

