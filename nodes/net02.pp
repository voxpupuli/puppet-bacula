node 'net02.dc1.puppetlabs.net' {

  include role::server

  ssh::allowgroup   { "techops": }
  sudo::allowgroup  { "techops": }
}
