class puppetlabs::burji {

  ssh::allowgroup  { "release": }
  sudo::allowgroup { "release": }

  include puppetlabs::service::pkgrepo


  file { "/var/www/index.html": ensure => absent; }

  apache::vhost {
    "$fqdn":
      port    => 80,
      options => "None",
      docroot => '/var/www'
  }

}

