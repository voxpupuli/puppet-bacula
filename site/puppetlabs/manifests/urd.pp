class puppetlabs::urd {
  include yum::mirror
  include pxe
  include jumpstart

  ssh::allowgroup   { "interns": }
  sudo::allowgroup  { "interns": }

}
