class puppetlabs::wyrd {

  apache::vhost {
    "wyrd.puppetlabs.lan":
      port    => 80,
      docroot => '/opt/www'
  }

}
