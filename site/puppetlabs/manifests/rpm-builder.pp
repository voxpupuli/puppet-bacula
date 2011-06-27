class puppetlabs::rpm-builder {
  ssh::allowgroup  { "release": }
  sudo::allowgroup { "release": }
}

