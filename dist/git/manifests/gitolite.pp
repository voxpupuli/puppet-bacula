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

  package { "gitolite":
    ensure => present,
  }
}
