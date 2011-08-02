class puppetlabs::deb-builder {
  ssh::allowgroup  { "release": }
  ssh::allowgroup  { "builder": }

  sudo::allowgroup { "release": }
  sudo::allowgroup { "builder": }
}
