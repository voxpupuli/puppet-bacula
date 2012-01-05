node idun {

  include role::server

  # Base
  include puppetlabs_ssl

  # Puppet Forge
  class { 'forge':
    vhost         => 'forge.puppetlabs.com',
    serveraliases => 'newforge.puppetlabs.com', # remove me at some point.
    github_url    => 'git@github.com:puppetlabs/puppet-forge.git',
    git_revision  => '32bdf3d7ddbdf92843e4bc437ce2aa9ee848209b',
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
