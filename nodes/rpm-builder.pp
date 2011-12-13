node rpm-builder {
  include role::server

  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }

  # Surprise jenkin users that was one-off'd
  # Putting this in puppet to avoid breakage.
  Account::User <| tag == 'jenkins' |>
}

