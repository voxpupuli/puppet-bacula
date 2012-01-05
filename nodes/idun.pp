node idun {

  include role::server

  # Base
  include puppetlabs_ssl

  # Puppet Forge
  class { 'forge':
    vhost         => 'forge.puppetlabs.com',
    serveraliases => 'newforge.puppetlabs.com', # remove me at some point.
    github_url    => 'git@github.com:puppetlabs/puppet-forge.git',
    git_revision  => 'f9529be2b6c3f3fd2e2db44aa1fda5e797e449e9',
    appserver     => 'unicorn',
    do_ssh_keys   => true,
  }

  nagios::website { 'forge.puppetlabs.com': }
  include munin
  include munin::puppet

  class { "bacula":
    director => hiera('bacula_director'),
    password => hiera('bacula_password'),
  }

}
