node web01 {
  include role::server

  ##################################################################
  # NOTE: Apache runs on port 82, nginx runs on port 80.
  # Get it right, or things break!
  $apache_port = '82'
  Apache::Vhost::Redirect { port => $apache_port }

  class { "pdns": ensure => absent; }
  include postfix
  include puppetlabs_ssl
  include puppetlabs::service::www  # Contains wordpresses for this
                                    # host. (www.pl.com, &c)
  class { "puppetlabs::docs": http_port => $apache_port; }

  apache::vhost::redirect {
    "docs.mirror0.puppetlabs.com":
      dest => 'http://docs.puppetlabs.com';
  }

  apache::vhost::redirect {
    'learningpuppet.com':
      dest => 'http://docs.puppetlabs.com/learning'
  }


  # allow syncing from development via ssh/sudo/mysql. This isn't hack
  # is it?
  $ssh_options = [ 'command="/usr/bin/sudo /usr/local/bin/wordpress_db_dumper.sh"' ]
  group{ 'wordpresssync': ensure      => present, } ->
  user{  'wordpresssync': ensure      => present, gid => 'wordpresssync', managehome => true, password => '*', } ->
  file{ '/home/wordpresssync': ensure => directory, owner => 'wordpresssync', group => 'wordpresssync', } ->
  ssh::allowgroup { 'wordpresssync': } ->
  sudo::entry{ "wordpresssync": entry => "wordpresssync ALL=(ALL) NOPASSWD: /usr/local/bin/wordpress_db_dumper.sh\n", } ->
  sudo::entry{ "wordpressrsync": entry => "wordpresssync ALL=(ALL) NOPASSWD: /usr/bin/rsync --server --sender -logDtprCe.iLsf . /var/www/puppetlabs.com/", } ->
  ssh_authorized_key{ 'wordpresssync@wordpresssync':
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Y9S5IxfMwDwiy8gMwYJ3dy5aAidOzRQJSTC84TsJ8GCtBabpyRlvmPi04q9h7qf6YY8ltY+1P3VyFvGNXzKrYvBRXs0atu2fr7RjsZqNIjpIAqLRadp+THx1jPdN8Dkk5ZRIC/3chOsY0GZ5ayu7N9JrUR8OBg0TbMvq7YAeG/cFWmNTQP02OVskF4nl9MDtEtigT3eLsDq5HjBc36koiiB85lptvds3uqDgiYG0D9AccgLD0zAu1aijWf7Xk9R5X7hwjokzKkaOF5S236T9GXFB2mrBHF/E1amrC59qd6eRTtJRrlmH+VXJSgIe0AAqv9af+F4JRcs8SVbf2gNF',
    type    => 'ssh-rsa',
    ensure  => 'present',
    user    => 'wordpresssync',
    options => $ssh_options,
  } ->
  ssh_authorized_key{ 'wordpressrsync@wordpresssync':
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDWtNmx5XnCrP+8jpBurQ6r9xdx9pPz4bS7lOmdwXpPfpz4mZvtO6nzsBWHh/THsJtHRHCA580UzK/4Y+7vBoIOxYUVbbiHssVcudLpZcTrhOCYr3skTwzANi0vc5449/GNdqAeHsT4xI59/XmJrlB9lhU/jLUpf1HESAZYt+5HvJnJZh84yb4JJD9CTqqDsBxFlA9DcMZ0VOJmGjjowvatpdMlgzy4N+pIRYPPuCisaEpho4sRsasjCvLmQTbRBd58Eeg4J5QVBtmx/ieq1uj09AJOCxiFN8MmJRrMWhY5xPPDDz5Yf79mhR7cDCRtO5ijgsLkBAdPNMj983lDD9Zl',
    type    => 'ssh-rsa',
    ensure  => 'present',
    user    => 'wordpresssync',
    options => [ 'command="sudo rsync --server --sender -logDtprCe.iLsf . /var/www/puppetlabs.com/"' ];
  }


}
