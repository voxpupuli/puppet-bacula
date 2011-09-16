node deb-builder {
  include role::server

  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }
}
