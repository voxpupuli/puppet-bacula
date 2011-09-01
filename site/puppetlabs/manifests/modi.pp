class puppetlabs::modi {
  ssh::allowgroup { "techops": }
  sudo::allowgroup { "techops": }
  
}
