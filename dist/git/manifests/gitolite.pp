# Class: git::gitolite
#
# This class installs gitolite on debian hosts
#
#
# Requires:
#  - Class[git]
#
#
class git::gitolite {
  include git

  # Resources for gitolite user
  ssh::allowgroup { "git": }
  Account::User <| title == 'git' |>
  Group         <| title == 'git' |>

  # Gitolite keys are self contained - adding keys here will break key
  # management within gitolite itself.
  Account::User["git"] {
    usekey => false,
  }

  package { "gitolite":
    ensure => present,
  }
}
