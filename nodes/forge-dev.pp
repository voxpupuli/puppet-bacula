node forge-dev {
  include role::server

  include postfix
  include vim

  class { 'forge':
      vhost       => 'forge-dev.puppetlabs.com',
      ssl         => false,
      newrelic    => false,
      do_ssh_keys => true,
      github_url  => 'git@github.com:puppetlabs/puppet-module-site.git',
  }

}
