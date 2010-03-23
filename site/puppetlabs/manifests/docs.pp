class puppetlabs::docs {
  #
  # This is temp so as to not purge the puppetlabs.com vhost.
  #
  file {'/etc/apache2/sites-enabled/puppetlabs.com': ensure => present }
  $docroot = '/var/www/docs.puppetlabs.com'
  apache::vhost {'docs.puppetlabs.com':
    port => 80,
    docroot => $docroot,
    ssl => false,
    priority => 20,
    template => 'puppetlabs/docs_vhost.erb'
  }    
  #
  # Since this sourced from git we should probably use VCS repo and a variable for the tag to make up date these files.
  #
  file {$docroot: ensure => directory, mode => '0755', owner => root, group => root, before => Apache::Vhost['docs.puppetlabs.com'] }
}
