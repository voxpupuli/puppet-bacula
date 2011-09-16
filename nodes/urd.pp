node urd {
  include role::server
  include yum::mirror
  #include pxe
  include jumpstart

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

}
