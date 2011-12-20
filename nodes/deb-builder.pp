node deb-builder {
  include role::server

  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }

  # (#11486) Setup 'deploy' user on deb-builder
  Account::User <| tag == deploy |>
  Ssh_authorized_key <| tag == deploy |>
  ssh::allowgroup { "www-data": }
  sudo::entry { "deploy": entry => "deploy ALL=(ALL) NOPASSWD: ALL\n" }
}
