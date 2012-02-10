class service::projects {

  include puppetlabs_ssl

  class { 'redmine':
    vhost         => 'projects.puppetlabs.com',
    serveraliases => ['projects.reductivelabs.com', 'newprojects.puppetlabs.com'],
    user          => 'redmine',
    group         => 'redmine',
    appserver     => 'unicorn',
    git_revision  => '12f60a564f708cf645a98d87553110100a61d130', #pl-1.3-stable branch
    github_url    => 'git@github.com:puppetlabs/redmine.git',
  }

}
