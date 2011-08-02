class puppetlabs::xaman {

  sudo::allowgroup  { "interns": }
  ssh::allowgroup   { "interns": }

  include okra::passenger
}
