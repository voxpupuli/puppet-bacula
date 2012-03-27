# = Class: service::gito
#
# == Purpose
#
#  - Installs and configures gitolite
#  - Sets up mirrors of github repositories
#  - Sets up and runs secure backups with duplicity

class service::gitolite {
  include git::gitolite


  # QA github mirrors
  github::mirror {
    "puppetlabs/facter":
      ensure => absent;
    "puppetlabs/puppet":
      ensure => absent;
    "puppetlabs/puppet-acceptance":
      ensure => absent;
    "puppetlabs/pe_acceptance_tests":
      ensure  => absent,
      private => true,
  }

  # Ops github mirrors
  github::mirror {
    "puppetlabs/puppetlabs-modules":
      private => true,
      ensure  => absent;
    "puppetlabs/puppetlabs-sysadmin-docs":
      private => true,
      ensure  => absent;
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
