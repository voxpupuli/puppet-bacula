class puppetlabs::xaman {

  sudo::allowgroup  { "interns": }
  ssh::allowgroup   { "interns": }

  include puppetlabs_ssl
  include okra::passenger
}
