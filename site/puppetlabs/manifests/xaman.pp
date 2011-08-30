class puppetlabs::xaman {

  sudo::allowgroup  { "interns": }
  ssh::allowgroup  { "developers": }
  ssh::allowgroup   { "interns": }

  sudo::entry {
    "randall-okra":
      entry => "randall ALL = (okra) NOPASSWD: ALL";
    "pvande-okra":
      entry => "pvande  ALL = (okra) NOPASSWD: ALL";
  }

  # yank cert installation while this is in a branch
  #include puppetlabs_ssl
  include okra::passenger
}
