class puppetlabs::xaman {

  sudo::allowgroup  { "interns": }
  ssh::allowgroup   { "interns": }

  include apache
  include passenger
  include git
}
