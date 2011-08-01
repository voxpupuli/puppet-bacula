class puppetlabs::clippy {

  sudo::allowgroup  { "interns": }
  ssh::allowgroup   { "interns": }

  include git::gitolite

  class { 'github::params':
    basedir    => "/home/git/repositories",
    vhost_name => "git.puppetlabs.lan",
  }

  github::mirror {
    "puppetlabs/facter":
      ensure => present;
    "puppetlabs/puppet":
      ensure => present;
  }
}
