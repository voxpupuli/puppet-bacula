class puppetlabs::docs (
  $http_port  ='80',
  $https_port ='443'
  ) {
  #
  # This is temp so as to not purge the puppetlabs.com vhost.
  #
  $docroot = '/var/www/docs.puppetlabs.com'

  apache::vhost::redirect {
    'docs.reductivelabs.com':
      port       => $http_port,
      dest       => 'http://docs.puppetlabs.com',
      status     => '301'
  }

  # This should be port 82 when running on web01
  apache::vhost {
    'docs.puppetlabs.com':
      port          => $http_port,
      docroot       => $docroot,
      template      => 'puppetlabs/docs_vhost.erb',
      ssl           => false,
      priority      => 20,
  }

  # HTTPS added for #9976
  apache::vhost {
    'docs.puppetlabs.com':
      port          => $https_port,
      docroot       => $docroot,
      template      => 'puppetlabs/docs_vhost.erb',
      ssl           => true,
      priority      => 20,
  }


  #
  # Since this sourced from git we should probably use VCS repo and a variable for the tag to make up date these files.
  #
  Account::User <| tag == 'deploy' |>
  ssh::allowgroup { "www-data": }

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
