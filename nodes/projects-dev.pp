node projects-dev {
  include role::server

  # SHA1 stolen from, pick a tag.
  # https://github.com/edavis10/redmine/commit/1faf02c9f5ce22ce676e7a3ae710dd0c52a21d45#
  $redmine_version_du_jour = '1faf02c9f5ce22ce676e7a3ae710dd0c52a21d45'

  $mysql_root_pw = 'n0tInpr0duct1on'

  # Base
  include puppetlabs_ssl

  # Requirements for redmine is it needs >1.1.0 for DB migrations
  package{
    'rack': provider => 'gem', ensure => '1.1.0';
  }

  include mysql::server
  redmine::unicorn { 'projects-dev.puppetlabs.com':
    dir     => '/opt',
    db      => 'projectsdevpuppetlabscom',
    db_user => 'redmine',
    db_pw   => 'notproductI0N',
    port    => '80',
    version => '1faf02c9f5ce22ce676e7a3ae710dd0c52a21d45',
  }

}
