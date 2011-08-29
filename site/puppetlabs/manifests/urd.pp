class puppetlabs::urd {
  include yum::mirror
  #include pxe
  include jumpstart

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }

  class { "nagios": nrpe_server => '173.255.196.32'; }

}
