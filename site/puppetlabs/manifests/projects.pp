class puppetlabs::projects {
  include puppetlabs
  redmine::instance {'projects.puppetlabs.com':
    db => 'projects.puppetlabs.com',
    db_user => 'redmine',
    db_pw => 'c@11-m3-m1st3r-p1t4ul',
    user => 'redmine',
    group => 'redmine',
    dir => '/var/www'
  }
}
