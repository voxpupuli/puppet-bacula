class puppetlabs::projects {
  include puppetlabs
  $mysql_root_pw= 'c@11-m3-m1st3r-p1t4ul'
  redmine::passenger {'projects.puppetlabs.com':
    dir => '/var/www',
    db => 'projectspuppetlabscom',
    db_user => 'redmine',
    db_pw => 'c@11-m3-m1st3r-p1t4ul',
    port => '80',
  }
  file{'/var/www':
    ensure => directory,
  }
}
