node idun {
  include role::server

  # Base
  include puppetlabs_ssl

  # Puppet Forge
  class { 'forge':
    vhost         => 'forge.puppetlabs.com',
    serveraliases => 'newforge.puppetlabs.com', # remove me at some point.
    github_url    => 'git@github.com:puppetlabs/puppet-forge.git',
    git_revision  => '0.3.1',
    appserver     => 'unicorn',
    do_ssh_keys   => true,
  }

  nagios::website { 'forge.puppetlabs.com': }
  include munin
  include munin::puppet

}
