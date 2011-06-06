class puppetlabs::bacula01 {

  ####
  # MySQL
  #
  $mysql_root_pw = 'y0PM46FbrF72'
  include mysql::server

  ####
  # Bacula
  #
  class { "bacula::director":
    db_user => 'bacula',
    db_pw   => 'ijdhx8jsd2KJshd',
  }

  bacula::director::pool {
    "PuppetLabsPool-Full":
      volret      => "3 months",
      maxvolbytes => '2000000000',
      maxvoljobs  => '2',
      label       => "Full-";
    "PuppetLabsPool-Inc":
      volret      => "21 days",
      maxvolbytes => '4000000000',
      maxvoljobs  => '50',
      label       => "Inc-";
  }

  $bacula_password = 'YgBDlDIYfOAYC6UYRX28QD3Q7S3UYLBuGUBW9'
  $bacula_director = 'bacula01.puppetlabs.lan'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }


}

