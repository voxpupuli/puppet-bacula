class service::projects {

  include puppetlabs_ssl

  class { 'redmine':
    vhost         => 'projects.puppetlabs.com',
    serveraliases => ['projects.reductivelabs.com', 'newprojects.puppetlabs.com'],
    user          => 'redmine',
    group         => 'redmine',
    appserver     => 'unicorn',
    git_revision  => '2435525db2c08c68e18cfde56b03bf654e6d92e9',
    github_url    => 'git@github.com:puppetlabs/redmine.git',
  }

}
