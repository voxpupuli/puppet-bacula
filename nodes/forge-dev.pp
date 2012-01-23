node forge-dev {
  include role::server

  include postfix
  include vim

  # Puppet Forge
  class { 'forge':
      vhost       => 'forge-dev.puppetlabs.com',
      ssl         => false,
      newrelic    => false,
      do_ssh_keys => true,
      appserver   => 'unicorn',
      github_url  => 'git@github.com:puppetlabs/puppet-forge.git',
      git_revision => 'latest',
  }

}
