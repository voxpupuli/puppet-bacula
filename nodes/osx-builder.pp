# = node: osx-builder
#
# (#11498)
#
node osx-builder {
  # adding this on OSX terrifies me
  # include role::server

  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }

  # (#11486) Setup 'jenkins' user on rpm-builder
  Account::User <| title == 'jenkins' |>
  Ssh_authorized_key <| user == 'jenkins' |>
  ssh::allowgroup { "jenkins": }
  sudo::allowgroup { "jenkins": }

}
