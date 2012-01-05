node sles-builder {

  include role::server

  ssh::allowgroup { "builder": }
  ssh::allowgroup { "release": }
  ssh::allowgroup { "techops": }

  sudo::allowgroup { "builder": }
  sudo::allowgroup { "release": }
  sudo::allowgroup { "techops": }

  # (#11486) Setup 'jenkins' user on rpm-builder
  Account::User <| title == 'jenkins' |>
  Ssh_authorized_key <| user == 'jenkins' |>
  ssh::allowgroup { "jenkins": }
  sudo::allowgroup { "jenkins": }
}
