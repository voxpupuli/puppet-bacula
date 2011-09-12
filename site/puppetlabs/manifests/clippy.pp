class puppetlabs::clippy {

  sudo::allowgroup  { "techops": }
  ssh::allowgroup   { "techops": }

  include git::gitolite

  file { "/var/www/git":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => "0755",
  }

  class { 'github::params':
    wwwroot    => "/var/www/git",
    basedir    => "/home/git/repositories",
    vhost_name => "git.puppetlabs.lan",
    require    => File["/var/www/git"],
  }

  github::mirror {
    "puppetlabs/facter":
      ensure => present;
    "puppetlabs/puppet":
      ensure => present;
    "puppetlabs/puppet-acceptance":
      ensure => present;
    "puppetlabs/pe_acceptance_tests":
      ensure  => present,
      private => true,
  }
}
