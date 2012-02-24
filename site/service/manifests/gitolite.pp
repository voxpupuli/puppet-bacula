# = Class: service::gito
#
# == Purpose
#
#  - Installs and configures gitolite
#  - Sets up mirrors of github repositories
#  - Sets up and runs secure backups with duplicity

class service::gitolite {
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

  # QA github mirrors
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

  # Ops github mirrors
  github::mirror {
    "puppetlabs/puppetlabs-modules":
      private => true,
      ensure  => present;
    "puppetlabs/puppetlabs-sysadmin-docs":
      private => true,
      ensure  => present;
  }

  gpg::agent { "git":
    options => [
      "--default-cache-ttl 999999999",
      "--max-cache-ttl     999999999",
      "--use-standard-socket",
    ],
  }

  duplicity::cron { "/home/git":
    user           => "git",
    target         => "ssh://gitbackups@bacula01.puppetlabs.lan:22//bacula/duplicity/git.puppetlabs.net",
    home           => "/home/git",
    mailto         => '',
    options        => [
      "--encrypt-key 409D0688",
      "--sign-key 409D0688",
      "--use-agent",
    ],
  }
}
