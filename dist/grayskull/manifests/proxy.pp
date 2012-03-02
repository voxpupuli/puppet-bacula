class grayskull::proxy ($servername = $fqdn, $port = 8080) {
  include nginx

  nginx::unicorn {
    'grayskull.puppetlabs.com':
      priority       => 8,
      unicorn_socket => 'http://localhost:8081',
      path           => '/dev/null',
      ssl            => true,
      ssl_port       => 8080,
      sslonly        => true,
      isdefaultvhost => true, # default for SSL.
      magic          => inline_template( "ssl_verify_client = on;\nssl_client_cert   = '${grayskull::installdir}/ssl/ca_crt.pem'\nssl_cert          = '${grayskull::installdir}/ssl/crt.pem'\nssl_key           = '${grayskull::installdir}/ssl/key.pem'\n" ),
  }


  file { "${grayskull::installdir}/ssl":
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0600,
    recurse => true;
  }
}
