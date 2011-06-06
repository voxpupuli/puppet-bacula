class puppetlabs::bacula01 {

  class { "bacula::director":
    db_user => 'bacula',
    db_pw   => 'ijdhx8jsd2KJshd',
  }

}

