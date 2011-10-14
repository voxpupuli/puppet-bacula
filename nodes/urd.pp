node urd {
  include role::server
  # yum mirroring has been moved to yo.puppetlabs.lan
  # include yum::mirror
  #include pxe
  include jumpstart

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

}
