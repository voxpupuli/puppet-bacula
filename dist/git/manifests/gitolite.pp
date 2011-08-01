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
  # Gitolite keys are self contained - adding keys here will break key
  # management within gitolite itself.
  Account::User <| title == 'git' |> { usekey => false, }
  Group         <| title == 'git' |>
  ssh::allowgroup { "git": }

  package { "gitolite":
    ensure => present,
  }
}
