class puppetlabs::lukedev01 {

  sudo::entry{ "luke": entry => "luke ALL=(ALL) NOPASSWD: ALL\n", }

}
