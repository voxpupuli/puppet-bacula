class puppetlabs::docs {
  #
  # This is temp so as to not purge the puppetlabs.com vhost.
  #
  $docroot = '/var/www/docs.puppetlabs.com'

  apache::vhost::redirect {
    'docs.reductivelabs.com':
      vhost_name => $ipaddress,
      port       => '80',
      dest       => 'http://docs.puppetlabs.com'
  }

  apache::vhost {
    'docs.puppetlabs.com':
      vhost_name    => $ipaddress,
      port          => 80,
      docroot       => $docroot,
      ssl           => false,
      priority      => 20,
  }
  #
  # Since this sourced from git we should probably use VCS repo and a variable for the tag to make up date these files.
  #
  Account::User <| tag == 'deploy' |>
  file {
    $docroot: 
      ensure => directory, 
      mode   => '0755', 
      owner  => deploy, 
      group  => root, 
      before => Apache::Vhost['docs.puppetlabs.com'] 
  }

  realize(A2mod['rewrite'])
}
