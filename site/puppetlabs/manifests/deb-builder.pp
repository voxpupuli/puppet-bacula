class puppetlabs::deb-builder {
  ssh::allowgroup  { "release": }
  sudo::allowgroup { "release": }
}

