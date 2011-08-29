class puppetlabs::urd {
  include yum::mirror
  #include pxe
  include jumpstart

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

}
