node idun {
  include role::server

  # Base
  include puppetlabs_ssl

  # Puppet Forge
  class { 'forge':
    vhost         => 'forge.puppetlabs.com',
    github_url    => 'git@github.com:puppetlabs/puppet-forge.git',
    git_revision  => '0.3.1',
    appserver     => 'unicorn',
    do_ssh_keys   => true,
  }

  nagios::website { 'forge.puppetlabs.com': }
  include munin
  include munin::puppet

  nginx::vhost::redirect {
    'newforge_to_forge':
      servername => 'newforge.puppetlabs.com',
      priority   => 77,
      port       => 80,
      dest       => 'http://forge.puppetlabs.com/',
  }
}
