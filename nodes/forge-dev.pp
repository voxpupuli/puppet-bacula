node forge-dev {
  include role::server

  include postfix
  include vim

  # Devs have full access as it's a staging/dev/warground.
  ssh::allowgroup { "developers": }
  sudo::allowgroup { "developers": }

  # Puppet Forge
  class { 'forge':
      vhost        => 'forge-dev.puppetlabs.com',
      ssl          => false,
      newrelic     => false,
      do_ssh_keys  => true,
      appserver    => 'unicorn',
      github_url   => 'git@github.com:puppetlabs/puppet-forge.git',
      git_revision => '2bda85278fb5cb806ac785b7044e1584826d052f',
  }

}
