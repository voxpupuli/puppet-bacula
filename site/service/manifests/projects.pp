class service::projects {

  include puppetlabs_ssl

  class { 'redmine':
    vhost         => 'projects.puppetlabs.com',
    serveraliases => ['projects.reductivelabs.com', 'newprojects.puppetlabs.com'],
    user          => 'redmine',
    group         => 'redmine',
    appserver     => 'unicorn',
    git_revision  => '1cd5725c209f68bab193a1e77986005d25ec5776', #pl-1.3-stable branch
    github_url    => 'git@github.com:puppetlabs/redmine.git',
  }

}
