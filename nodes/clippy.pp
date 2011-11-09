# clippy, aka git.puppetlabs.net
#
# Hosts gitolite for github mirrors as well as puppetlabs private repos.

node clippy {
  include role::server
  include puppetlabs::service::gitolite

  sudo::allowgroup  { "techops": }
  ssh::allowgroup   { "techops": }

  gpg::agent { "git": }

  duplicity::cron {"/home/git":
    user   => "git",
    target => "ssh://gitbackups@bacula01.puppetlabs.lan:22/bacula/duplicity/git.puppetlabs.net",
    options => [
      "--encrypt-key 409D0688",
      "--sign-key 409D0688",
      "--use-agent",
    ],
  }
}

