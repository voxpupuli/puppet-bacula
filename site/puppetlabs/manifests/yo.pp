class puppetlabs::yo {

  ssh::allowgroup  { "techops": }
  sudo::allowgroup { "techops": }

  # stahnma needs root to work on some repo things.
  sudo::entry{ "stahnma":
    entry => "stahnma ALL=(ALL) NOPASSWD: ALL\n",
  }

  include puppetlabs::service::mrepo
  include puppetlabs::service::repoclosure
}

