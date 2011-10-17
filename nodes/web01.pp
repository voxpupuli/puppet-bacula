node web01 {
  include role::server

  ##################################################################
  # NOTE: Apache runs on port 82, nginx runs on port 80.
  # Get it right, or things break!
  $apache_port = '82'
  Apache::Vhost::Redirect { port => $apache_port }

  include pdns
  include postfix
  include puppetlabs_ssl
  include puppetlabs::service::www  # Contains wordpresses for this
                                    # host. (madstop, www.pl.com, &c)
  class { "puppetlabs::docs": http_port => $apache_port; }

  apache::vhost::redirect {
    "docs.mirror0.puppetlabs.com":
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
      dest => 'http://docs.puppetlabs.com/learning'
  }


  # allow syncing from development via ssh/sudo/mysql. This isn't hack
  # is it?
  group{ 'wordpresssync': ensure => present, } ->
  user{  'wordpresssync': ensure => present, password => '*', } ->
  ssh::allowgroup { 'wordpresssync': } ->
  sudo::entry{ "wordpresssync": entry => "wordpresssync ALL=(ALL) NOPASSWD: /usr/local/bin/wordpress_db_dumper.sh\n", }

}
