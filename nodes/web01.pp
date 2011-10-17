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
  $ssh_options = [ "command='/usr/local/bin/wordpress_db_dumper.sh'" , "from=192.168.100.18" ]
  group{ 'wordpresssync': ensure      => present, } ->
  user{  'wordpresssync': ensure      => present, gid => 'wordpresssync', managehome => true, password => '*', } ->
  file{ '/home/wordpresssync': ensure => directory, owner => 'wordpresssync', group => 'wordpresssync', } ->
  ssh::allowgroup { 'wordpresssync': } ->
  sudo::entry{ "wordpresssync": entry => "wordpresssync ALL=(ALL) NOPASSWD: /usr/local/bin/wordpress_db_dumper.sh\n", } ->
  ssh_authorized_key{ 'wordpresssync@wordpresssync':
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Y9S5IxfMwDwiy8gMwYJ3dy5aAidOzRQJSTC84TsJ8GCtBabpyRlvmPi04q9h7qf6YY8ltY+1P3VyFvGNXzKrYvBRXs0atu2fr7RjsZqNIjpIAqLRadp+THx1jPdN8Dkk5ZRIC/3chOsY0GZ5ayu7N9JrUR8OBg0TbMvq7YAeG/cFWmNTQP02OVskF4nl9MDtEtigT3eLsDq5HjBc36koiiB85lptvds3uqDgiYG0D9AccgLD0zAu1aijWf7Xk9R5X7hwjokzKkaOF5S236T9GXFB2mrBHF/E1amrC59qd6eRTtJRrlmH+VXJSgIe0AAqv9af+F4JRcs8SVbf2gNF',
    type    => 'ssh-dss',
    ensure  => 'present',
    user    => 'wordpresssync',
    options => $ssh_options,
  }

}
