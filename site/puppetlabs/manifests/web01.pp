class puppetlabs::web01 {

  include postfix
  include puppetlabs::service::www
  class { "puppetlabs::docs": port => 82; }

  apache::vhost::redirect {
    "docs.mirror0.puppetlabs.com":
      port => '80',
      dest => 'http://docs.puppetlabs.com';
  }

  # Bacula
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '4tc39KValGRv4xqhXhn5X4MsrHB5pQZbMfnzDt'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

}

