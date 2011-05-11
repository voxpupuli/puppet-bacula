class puppetlabs::app01 {
  include patchwork

  ssh::allowgroup { "developers": }

}
