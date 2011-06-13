class puppetlabs::projects-dev {

  $mysql_root_pw = 'n0tInpr0duct1on'

  # Base
  include puppetlabs_ssl

  # Requirements for redmine is it needs >1.1.0 for DB migrations
  package{
    'rack': provider => 'gem', ensure => '1.1.0';
  }

  # I HATE YOU RUBYGEMS
  exec{ 'gem cleanup rack':
    path   => "/usr/bin:/usr/sbin:/bin",
    onlyif => "gem list '^rack$' | grep -q ','"
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
