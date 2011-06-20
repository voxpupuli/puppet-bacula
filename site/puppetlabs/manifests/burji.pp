class puppetlabs::burji {

  ssh::allowgroup  { "release": }
  sudo::allowgroup { "release": }

  include puppetlabs::service::pkgrepo

  # Bacula
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '4tc39KValGRv4xqhXhn5X4MsrHB5pQZbMfnzDt'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

  file { "/var/www/index.html": ensure => absent; }

  apache::vhost {
    "$fqdn":
      port    => 80,
      options => "None",
      docroot => '/var/www'
  }

}

