node sles-builder inherits server {

  ssh::allowgroup { "builder": }
  ssh::allowgroup { "release": }
  ssh::allowgroup { "techops": }

  sudo::allowgroup { "builder": }
  sudo::allowgroup { "release": }
  sudo::allowgroup { "techops": }
}
