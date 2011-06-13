class puppetlabs::projects-dev {

  $mysql_root_pw = 'n0tInpr0duct1on'

  # Base
  include puppetlabs_ssl

  # Requirements for redmine is it needs >1.1.0 for DB migrations
  package{
    'rack': provider => 'gem', ensure => '1.2.0';
  }

  include mysql::server
  redmine::unicorn { 'projects-dev.puppetlabs.com':
    dir     => '/opt',
    db      => 'projectsdevpuppetlabscom',
    db_user => 'redmine',
    db_pw   => 'notproductI0N',
    port    => '80',
  }

}
