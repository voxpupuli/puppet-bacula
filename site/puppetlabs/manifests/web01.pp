class puppetlabs::web01 {

  ##################################################################
  # NOTE: Apache runs on port 82, nginx runs on port 80.
  # Get it right, or things break!
  $apache_port = '82'

  include pdns
  include postfix
  include puppetlabs_ssl
  include puppetlabs::service::www  # Contains wordpresses for this
                                    # host. (madstop, www.pl.com, &c)
  class { "puppetlabs::docs": port => $apache_port; }

  apache::vhost::redirect {
    "docs.mirror0.puppetlabs.com":
      port => $apache_port,
      dest => 'http://docs.puppetlabs.com';
  }

  # Bacula
  $bacula_director = 'baal.puppetlabs.com'
  $bacula_password = '4tc39KValGRv4xqhXhn5X4MsrHB5pQZbMfnzDt'
  class { "bacula":
    director => $bacula_director,
    password => $bacula_password,
  }

  apache::vhost::redirect {
    'learningpuppet.com':
      port => $apache_port,
      dest => 'http://docs.puppetlabs.com/learning'
  }

}

