node rpm-builder {
  include role::server

  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }

  # Surprise jenkin users that was one-off'd
  # Putting this in puppet to avoid breakage.
  Account::User <| tag == 'jenkins' |>

  # (#11486) Setup 'deploy' user on rpm-builder
  Account::User <| tag == deploy |>
  Ssh_authorized_key <| tag == deploy |>
  ssh::allowgroup { "www-data": }
  sudo::entry { "deploy": entry => "deploy ALL=(ALL) NOPASSWD: ALL\n" }
}

