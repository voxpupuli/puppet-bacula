class puppetlabs::web01 {

  include postfix
  include puppetlabs_ssl
  include puppetlabs::service::www
  class { "puppetlabs::docs": port => 82; }

  apache::vhost::redirect {
    "docs.mirror0.puppetlabs.com":
      port => '82',
      dest => 'http://docs.puppetlabs.com';
  }

  # Bacula
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '4tc39KValGRv4xqhXhn5X4MsrHB5pQZbMfnzDt'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }


  file{ '/tmp/maint/':
    ensure => directory,
    mode   => '0755',
  }
  file{ '/tmp/maint/index.html':
    content => "<html><head><title>PuppetLabs</title></head><body>We're sorry, but we're currently migrating this machine to another host to make it better. Yeah!</body></html>",
    owner   => 'www-data',
    mode    => '0644',
    require => File['/tmp/maint/'],
  }

  apache::vhost {
    'maint.puppetlabs.com_ssl':
      serveraliases => [ 'forge.puppetlabs.com', 'projects.puppetlabs.com' ],
      port          => 443,
      priority      => 10,
      docroot       => '/tmp/maint/',
      ssl           => true,
      template      => 'puppetlabs/ssl_vhost.conf.erb',
      require       => File['/tmp/maint/index.html'],
  }

  apache::vhost::redirect {
    'maint.puppetlabs.com':
      port => 82,
      dest => 'https://projects.puppetlabs.com',
  }

}

