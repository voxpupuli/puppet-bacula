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
    db_user  => 'bacula',
    db_pw    => 'ijdhx8jsd2KJshd',
    monitor  => false,
    password => 'lVLthzlHuSWVgmCDXQpWw8sUIeInjXmD7DS3XGA7CkHszfKWVtmimLt27D6yV4R',
    sd_pass  => 'Z86VoTNrZEmGZxJ8rK7RenUeHvyUVeWZJK7ZHnYDE9Vhery0M2fW7Q8ZesbcXHk',
  }

  bacula::director::pool {
    "PuppetLabsPool-Full":
      volret      => "2 months",
      maxvolbytes => '2000000000',
      maxvoljobs  => '10',
      maxvols     => "20",
      label       => "Full-";
    "PuppetLabsPool-Inc":
      volret      => "14 days",
      maxvolbytes => '4000000000',
      maxvoljobs  => '50',
      maxvols     => "10",
      label       => "Inc-";
  }

  $bacula_password = 'YgBDlDIYfOAYC6UYRX28QD3Q7S3UYLBuGUBW9'
  $bacula_director = 'bacula01.puppetlabs.lan'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
    monitor  => false,
  }

  bacula::fileset {
    "Common":
      files => ["/etc"],
  }

}

