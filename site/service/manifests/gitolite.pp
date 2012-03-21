# = Class: service::gito
#
# == Purpose
#
#  - Installs and configures gitolite
#  - Sets up mirrors of github repositories
#  - Sets up and runs secure backups with duplicity

class service::gitolite {
  #include git::gitolite

  # Resources for gitolite user
  # Gitolite keys are self contained - adding keys here will break key
  # management within gitolite itself.
  Account::User <| title == 'git' |>
  Group         <| title == 'git' |>
  ssh::allowgroup { "git": }


  class {'::gitolite': }

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
