node rpm-builder {
  include role::server

  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }

  # Surprise jenkin users that was one-off'd
  # Putting this in puppet to avoid breakage.
  Account::User <| tag == 'jenkins' |>

  # (#11486) Setup 'jenkins' user on rpm-builder
  Account::User <| title == 'jenkins' |>
  Ssh_authorized_key <| user == 'jenkins' |>
  ssh::allowgroup { "jenkins": }
  sudo::allowgroup { "jenkins": }
}
