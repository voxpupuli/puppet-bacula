class puppetlabs::projects-dev {

  $mysql_root_pw = 'n0tInpr0duct1on'

  # Base
  include puppetlabs::lan
  include puppetlabs_ssl

  include mysql::server
  redmine::unicorn { 'projects-dev.puppetlabs.com':
    dir => '/opt',
    db => 'projectsdevpuppetlabscom',
    db_user => 'redmine',
    db_pw => 'notproductI0N',
    port => '80',
  }

}
