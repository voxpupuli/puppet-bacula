# = Class: service::gito
#
# == Purpose
#
#  - Installs and configures gitolite
#  - Sets up mirrors of github repositories
#  - Sets up and runs secure backups with duplicity

class service::gitolite {

  # Resources for gitolite user
  # Gitolite keys are self contained - adding keys here will break key
  # management within gitolite itself.
  Account::User <| title == 'git' |>
  Group         <| title == 'git' |>
  ssh::allowgroup { "git": }


  class {'::gitolite': manage_user => false,}
  gitolite::adc { 'adc.common-functions': mode => '0600'}

  gitolite::adc { 'fork': }
  gitolite::adc { 'getdesc': }
  gitolite::adc { 'help': }
  gitolite::adc { 'hub': }
  gitolite::adc { 'list-trash': }
  gitolite::adc { 'lock': }
  gitolite::adc { 'perms': }
  gitolite::adc { 'restore': }
  gitolite::adc { 'setdesc': }
  gitolite::adc { 'sskm': }
  gitolite::adc { 'trash': }
  gitolite::adc { 'unlock': }

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
