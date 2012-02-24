# = Node: clippy
#
# == Description
#
# This host provides a general purpose gitolite instance with secure backups.
#
# To view accessible git repositories, run `ssh git@git.puppetlabs.net info`
#
# == Other names
#
# - git.puppetlabs.lan
# - git.puppetlabs.net
node clippy {
  include role::server
  include service::gitolite

  sudo::allowgroup  { "techops": }
  ssh::allowgroup   { "techops": }

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
