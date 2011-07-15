class puppetlabs::yo {

  ssh::allowgroup { "interns": }
  sudo::allowgroup { "interns": }

  # stahnma needs root to work on some repo things.
  sudo::entry{ "stahnma":
    entry => 'stahnma ALL=(ALL) NOPASSWD: ALL\n',
  }

  include puppetlabs::service::mrepo

}
