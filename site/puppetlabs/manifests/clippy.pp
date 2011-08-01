class puppetlabs::clippy {

  sudo::allowgroup  { "interns": }
  ssh::allowgroup   { "interns": }
  ssh::allowgroup   { "git": }

  # Resources for gitolite
  Account::User <| title == 'git' |>
  Group         <| title == 'git' |>

  package { "gitolite":
    ensure => present,
  }
}

