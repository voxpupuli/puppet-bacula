class grayskull::proxy (
    $servername = $fqdn, 
    $port       = 8080
) {
  include grayskull::params

  nginx::unicorn {
    "grayskull.${domain}":
      priority       => 8,
      unicorn_socket => 'http://localhost:8081',
      path           => '/dev/null',
      ssl            => true,
      ssl_port       => 8080,
      sslonly        => true,
      isdefaultvhost => true, # default for SSL.
      template       => 'grayskull/vhost-unicorn.conf.erb',
  }

  file { "${grayskull::installdir}/ssl":
    ensure  => directory,
    owner   => $grayskull::params::wwwuser,
    group   => $grayskull::params::wwwgroup,
    mode    => 0600,
    recurse => true;
  }

}
